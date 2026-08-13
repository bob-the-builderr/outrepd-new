"use client";
import { useEffect, useState } from "react";

const TIER_NAMES = [
  "Iron",
  "Bronze",
  "Silver",
  "Gold",
  "Platinum",
  "Emerald",
  "Diamond",
  "Master",
  "Legend",
];
const DIV_NAMES = ["IV", "III", "II", "I"];

export default function JoinPage({ params }) {
  const code = params.code;
  const [match, setMatch] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [copied, setCopied] = useState(false);
  const [expired, setExpired] = useState(false);

  useEffect(() => {
    const fetchMatch = async () => {
      try {
        const res = await fetch(`/api/matches/invite/${code}`);
        if (!res.ok) {
          if (res.status === 404)
            setError("This invite link has expired or doesn't exist.");
          else setError("Something went wrong.");
          return;
        }
        const data = await res.json();
        setMatch(data.match);
        setExpired(data.expired || false);
      } catch {
        setError("Could not load match info.");
      } finally {
        setLoading(false);
      }
    };
    fetchMatch();
  }, [code]);

  useEffect(() => {
    if (typeof window === "undefined") return;

    const appUrl = window.location.origin;
    const pageUrl = `${appUrl}/join/${code}`;
    const imageUrl = `${appUrl}/api/og/join/${code}`;
    const hostName = match?.host_name || "A player";
    const muscle = match?.muscle_group ? ` · ${match.muscle_group}` : "";

    const metaDefs = [
      { property: "og:type", content: "website" },
      { property: "og:url", content: pageUrl },
      { property: "og:site_name", content: "OUTREPD" },
      {
        property: "og:title",
        content: `${hostName} challenges you to a gym battle!`,
      },
      {
        property: "og:description",
        content: `Join ${hostName}'s ranked match on OUTREPD${muscle}. Open the app, tap JOIN A MATCH and enter code ${code}.`,
      },
      { property: "og:image", content: imageUrl },
      { property: "og:image:width", content: "1200" },
      { property: "og:image:height", content: "630" },
      { property: "og:image:type", content: "image/svg+xml" },
      { name: "twitter:card", content: "summary_large_image" },
      {
        name: "twitter:title",
        content: `${hostName} challenges you to a gym battle!`,
      },
      {
        name: "twitter:description",
        content: `Join ${hostName}'s ranked match on OUTREPD${muscle}. Enter code ${code} in the app.`,
      },
      { name: "twitter:image", content: imageUrl },
    ];

    const prevTitle = document.title;
    document.title = `${hostName} challenges you · OUTREPD`;

    const injected = [];
    metaDefs.forEach(({ property, name, content }) => {
      const selector = property
        ? `meta[property="${property}"]`
        : `meta[name="${name}"]`;
      let el = document.head.querySelector(selector);
      const isNew = !el;
      if (!el) {
        el = document.createElement("meta");
        if (property) el.setAttribute("property", property);
        if (name) el.setAttribute("name", name);
        document.head.appendChild(el);
      }
      el.setAttribute("content", content);
      if (isNew) injected.push(el);
    });

    return () => {
      document.title = prevTitle;
      injected.forEach((el) => el.parentNode?.removeChild(el));
    };
  }, [code, match]);

  const copyCode = () => {
    navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div
      style={{
        minHeight: "100vh",
        backgroundColor: "#010308",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: "24px",
        fontFamily: "system-ui, -apple-system, sans-serif",
      }}
    >
      <div
        style={{
          width: "100%",
          maxWidth: "420px",
          textAlign: "center",
        }}
      >
        {/* Logo */}
        <div style={{ marginBottom: "32px" }}>
          <span style={{ fontSize: "40px" }}>⚔️</span>
          <h1
            style={{
              color: "#FFF",
              fontSize: "28px",
              fontWeight: 900,
              margin: "8px 0 4px",
            }}
          >
            OUTREPD
          </h1>
          <p style={{ color: "#555", fontSize: "14px", margin: 0 }}>
            Competitive Gym Battles
          </p>
        </div>

        {loading && (
          <div style={{ color: "#888", fontSize: "16px" }}>
            Loading match info...
          </div>
        )}

        {error && (
          <div
            style={{
              backgroundColor: "#1A0808",
              border: "1px solid #FF4444",
              borderRadius: "16px",
              padding: "24px",
              color: "#FF4444",
              fontSize: "16px",
            }}
          >
            {error}
          </div>
        )}

        {expired && !error && (
          <div
            style={{
              backgroundColor: "#1A0808",
              border: "1px solid #FF4444",
              borderRadius: "16px",
              padding: "24px",
              color: "#FF4444",
              fontSize: "16px",
            }}
          >
            This invite link has expired
          </div>
        )}

        {match && !error && !expired && (
          <>
            <div
              style={{
                backgroundColor: "#0D1218",
                border: "1px solid #1A2630",
                borderRadius: "20px",
                padding: "28px",
                marginBottom: "24px",
              }}
            >
              <p
                style={{
                  color: "#4BB8FA",
                  fontWeight: 700,
                  fontSize: "12px",
                  letterSpacing: "2px",
                  margin: "0 0 8px",
                }}
              >
                YOU'VE BEEN CHALLENGED!
              </p>
              <p
                style={{
                  color: "#FFF",
                  fontSize: "22px",
                  fontWeight: 900,
                  margin: "0 0 4px",
                }}
              >
                {match.host_name || "A Player"}
              </p>
              <p
                style={{ color: "#888", fontSize: "14px", margin: "0 0 20px" }}
              >
                {TIER_NAMES[match.host_tier_idx] ?? "Iron"}{" "}
                {DIV_NAMES[match.host_div_idx] ?? "IV"}
              </p>

              <div
                style={{
                  backgroundColor: "#070D14",
                  borderRadius: "12px",
                  padding: "14px",
                  marginBottom: "20px",
                  border: "1px solid #0D1A24",
                }}
              >
                <p
                  style={{
                    color: "#555",
                    fontSize: "11px",
                    margin: "0 0 4px",
                    fontWeight: 700,
                  }}
                >
                  MUSCLE GROUP
                </p>
                <p
                  style={{
                    color: "#FFF",
                    fontSize: "20px",
                    fontWeight: 900,
                    margin: 0,
                  }}
                >
                  💪 {match.muscle_group?.toUpperCase()}
                </p>
              </div>

              {/* Invite Code */}
              <div
                style={{
                  backgroundColor: "#070D14",
                  borderRadius: "12px",
                  padding: "14px",
                  border: "1px solid #0D1A24",
                }}
              >
                <p
                  style={{
                    color: "#555",
                    fontSize: "11px",
                    margin: "0 0 8px",
                    fontWeight: 700,
                  }}
                >
                  ENTER THIS CODE IN THE APP
                </p>
                <p
                  style={{
                    color: "#4BB8FA",
                    fontSize: "28px",
                    fontWeight: 900,
                    letterSpacing: "4px",
                    margin: "0 0 12px",
                    fontVariantNumeric: "tabular-nums",
                  }}
                >
                  {code}
                </p>
                <button
                  onClick={copyCode}
                  style={{
                    backgroundColor: copied ? "#00C853" : "#0D1A24",
                    border: "1px solid #1A2A3A",
                    borderRadius: "8px",
                    color: copied ? "#FFF" : "#4BB8FA",
                    fontSize: "13px",
                    fontWeight: 700,
                    padding: "8px 20px",
                    cursor: "pointer",
                    transition: "all 0.2s",
                  }}
                >
                  {copied ? "✓ Copied!" : "Copy Code"}
                </button>
              </div>
            </div>

            {/* Instructions */}
            <div
              style={{
                backgroundColor: "#0A1008",
                border: "1px solid #0E1E0E",
                borderRadius: "16px",
                padding: "20px",
                textAlign: "left",
              }}
            >
              <p
                style={{
                  color: "#00C853",
                  fontWeight: 700,
                  fontSize: "12px",
                  margin: "0 0 12px",
                  letterSpacing: "1px",
                }}
              >
                HOW TO JOIN
              </p>
              {[
                "Open the OUTREPD app",
                'Tap "JOIN A MATCH" on the home screen',
                `Enter code: ${code}`,
                "Log your workout & win!",
              ].map((step, i) => (
                <div
                  key={i}
                  style={{
                    display: "flex",
                    alignItems: "flex-start",
                    gap: "10px",
                    marginBottom: "10px",
                  }}
                >
                  <span
                    style={{
                      backgroundColor: "#4BB8FA",
                      color: "#000",
                      borderRadius: "50%",
                      width: "22px",
                      height: "22px",
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      fontSize: "11px",
                      fontWeight: 900,
                      flexShrink: 0,
                    }}
                  >
                    {i + 1}
                  </span>
                  <span
                    style={{
                      color: "#888",
                      fontSize: "14px",
                      lineHeight: "22px",
                    }}
                  >
                    {step}
                  </span>
                </div>
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  );
}
