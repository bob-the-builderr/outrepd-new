import sql from "@/app/api/utils/sql";
import { corsResponse, handleCorsPreFlight } from "@/app/api/utils/cors";
import { sendEmail } from "@/app/api/utils/send-email";

export async function OPTIONS(request) {
  return handleCorsPreFlight(request);
}

export async function POST(request) {
  try {
    const { email } = await request.json();

    if (!email || typeof email !== "string") {
      return corsResponse(
        { error: "Email is required" },
        { status: 400 },
        request,
      );
    }

    const normalizedEmail = email.trim().toLowerCase();

    // Generate a 6-digit code
    const code = Math.floor(100000 + Math.random() * 900000).toString();

    // Delete any existing token for this email, then insert fresh one
    await sql`DELETE FROM auth_verification_token WHERE identifier = ${normalizedEmail}`;

    const expires = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes
    await sql`
      INSERT INTO auth_verification_token (identifier, token, expires)
      VALUES (${normalizedEmail}, ${code}, ${expires})
    `;

    // Send email via Resend
    try {
      await sendEmail({
        from: process.env.RESEND_FROM_EMAIL || "onboarding@resend.dev",
        to: normalizedEmail,
        subject: `Your OUTREPD login code: ${code}`,
        html: `
          <div style="font-family: sans-serif; background: #010308; color: #fff; padding: 40px; border-radius: 16px; max-width: 480px; margin: 0 auto;">
            <img src="https://dtvoeevhaseb5.cloudfront.net/user-uploads/10341004-1568-4639-9f40-8061c2cb7d4a.png" width="72" height="72" style="display:block; margin: 0 auto 16px;" />
            <h1 style="text-align:center; letter-spacing: 2px; color: #fff; margin-bottom: 8px;">OUTREPD</h1>
            <p style="text-align:center; color: #888; margin-bottom: 32px;">Competitive Gym Battles</p>
            <p style="text-align:center; color: #aaa; margin-bottom: 16px;">Your login code is:</p>
            <div style="background: #0D1218; border: 1px solid #1A2630; border-radius: 16px; padding: 32px; text-align: center; margin-bottom: 24px;">
              <span style="font-size: 48px; font-weight: 900; letter-spacing: 12px; color: #4BB8FA;">${code}</span>
            </div>
            <p style="text-align:center; color: #555; font-size: 13px;">This code expires in 15 minutes. If you didn't request this, ignore this email.</p>
          </div>
        `,
      });
    } catch (emailErr) {
      console.error("[Magic Request] Email send failed:", emailErr);
      return corsResponse(
        {
          error:
            "Failed to send email. Please check your Resend API key and try again.",
        },
        { status: 500 },
        request,
      );
    }

    return corsResponse({ success: true }, {}, request);
  } catch (err) {
    console.error("[Magic Request] Error:", err);
    return corsResponse(
      { error: "Something went wrong. Please try again." },
      { status: 500 },
      request,
    );
  }
}
