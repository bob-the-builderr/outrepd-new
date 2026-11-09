// "What's New" for 1.1.7, every locale. The thirteen languages the app speaks
// get their own text; every other locale gets English, as the app itself
// shows English wherever it does not speak the language. Every claim is
// checked against lib/: a challenge link is one try each (challenge.sql);
// the plan is six weeks with a Sunday race (plan.dart); awards are 14
// families from Bronze to Diamond with three pinned (awards/families.dart);
// moments and the month's recap (moments.dart); a friend passing you this
// week is a notice (notify.sql, notify_passed); a rewarded video doubles a
// won match's XP or brings back a streak (rewarded.sql, rewards.dart);
// photos reach every board (face.dart). The English stays under 500
// characters, Google Play's limit. Nothing the store forbids: no prices, no
// "free".
const en =
  "New: dare anyone with a link. Send your minute and they race it, one try each. Beat last week's you with a six-week plan and a race every Sunday. Awards rebuilt: 14 medal families from Bronze to Diamond, and your best three pinned to your profile. Screens for a new personal best and every milestone, a recap of each month, and a heads-up when a friend passes you this week. Watch a short video to double a win's XP or keep a broken streak. Photos now show for everyone.";
const de =
  'Neu: Fordere jeden per Link heraus. Schick deine Minute, und sie treten dagegen an, ein Versuch pro Person. Schlag dich von letzter Woche mit einem Sechs-Wochen-Plan und einem Rennen jeden Sonntag. Auszeichnungen neu: 14 Medaillen-Familien von Bronze bis Diamant, deine besten drei auf deinem Profil. Eigene Momente für neue Bestleistungen und jeden Meilenstein, ein Rückblick auf jeden Monat und ein Hinweis, wenn dich ein Freund diese Woche überholt. Ein kurzes Video verdoppelt die XP eines Siegs oder rettet eine gerissene Serie. Fotos sieht jetzt jeder.';
const es =
  'Novedades: reta a quien quieras con un enlace. Envía tu minuto y lo superan, un intento cada uno. Supera a tu yo de la semana pasada con un plan de seis semanas y una carrera cada domingo. Premios renovados: 14 familias de medallas de Bronce a Diamante y tus tres mejores en tu perfil. Pantallas para cada récord personal y cada hito, un resumen de cada mes y un aviso cuando un amigo te adelanta esta semana. Un vídeo corto duplica la XP de una victoria o salva una racha rota. Ahora todos ven las fotos.';
const fr =
  "Nouveau : défie n'importe qui avec un lien. Envoie ta minute, chacun a un essai pour la battre. Bats toi de la semaine dernière avec un plan de six semaines et une course chaque dimanche. Récompenses repensées : 14 familles de médailles, du Bronze au Diamant, et tes trois meilleures sur ton profil. Des écrans pour chaque record perso et chaque cap, un bilan de chaque mois, et une alerte quand un ami te dépasse cette semaine. Une courte vidéo double l'XP d'une victoire ou sauve une série. Les photos s'affichent pour tous.";
const it =
  'Novità: sfida chiunque con un link. Manda il tuo minuto e lo affrontano, un tentativo a testa. Batti il te della settimana scorsa con un piano di sei settimane e una sfida ogni domenica. Premi rinnovati: 14 famiglie di medaglie dal Bronzo al Diamante e le tue tre migliori sul profilo. Schermate per ogni record personale e ogni traguardo, un riepilogo di ogni mese e un avviso quando un amico ti supera questa settimana. Un breve video raddoppia gli XP di una vittoria o salva una serie interrotta. Ora tutti vedono le foto.';
const pt =
  'Novidades: desafie qualquer pessoa com um link. Envie seu minuto e cada um tem uma tentativa para superá-lo. Vença você da semana passada com um plano de seis semanas e uma disputa todo domingo. Prêmios renovados: 14 famílias de medalhas do Bronze ao Diamante e as suas três melhores no perfil. Telas para cada recorde pessoal e cada marco, um resumo de cada mês e um aviso quando um amigo passa você nesta semana. Um vídeo curto dobra o XP de uma vitória ou salva uma sequência. Agora todos veem as fotos.';
const ru =
  'Новое: бросай вызов кому угодно по ссылке. Отправь свою минуту, у каждого одна попытка её побить. Победи себя прошлой недели с шестинедельным планом и гонкой каждое воскресенье. Награды заново: 14 семейств медалей от бронзы до алмаза, лучшие три в твоём профиле. Отдельные экраны для личного рекорда и каждого рубежа, итоги каждого месяца и сигнал, когда друг обходит тебя на этой неделе. Короткое видео удваивает XP за победу или спасает прерванную серию. Фото теперь видят все.';
const tr =
  'Yeni: herkese bir bağlantıyla meydan oku. Dakikanı gönder, herkesin onu geçmek için bir hakkı olsun. Altı haftalık plan ve her pazar bir yarışla geçen haftaki seni yen. Ödüller yenilendi: Bronzdan Elmasa 14 madalya ailesi ve en iyi üçün profilinde. Her kişisel rekor ve her eşik için ayrı ekran, her ayın özeti ve bu hafta bir arkadaşın seni geçtiğinde bir uyarı. Kısa bir video bir galibiyetin XP’sini ikiye katlar ya da bozulan seriyi kurtarır. Fotoğraflar artık herkese görünüyor.';
const ja =
  '新機能：リンクで誰にでも挑戦。あなたの1分を送れば、みんな1回ずつ挑めます。6週間のプランと毎週日曜のレースで先週の自分に勝とう。アワードを一新：ブロンズからダイヤモンドまで14系統のメダル、ベスト3をプロフィールに。自己ベストや節目ごとの専用画面、毎月のまとめ、今週フレンドに抜かれたときのお知らせ。短い動画で勝利のXPを2倍にしたり、途切れた連続記録を取り戻せます。写真がみんなに表示されるようになりました。';
const ko =
  '새 기능: 링크로 누구에게나 도전하세요. 내 1분을 보내면 모두 한 번씩 도전할 수 있어요. 6주 플랜과 매주 일요일 레이스로 지난주의 나를 이겨 보세요. 어워드 개편: 브론즈부터 다이아몬드까지 14개 메달 계열, 최고의 3개를 프로필에 고정. 개인 최고 기록과 모든 마일스톤 전용 화면, 매달의 요약, 이번 주에 친구가 나를 앞질렀을 때 알림. 짧은 영상으로 승리 XP를 두 배로 하거나 끊긴 연속 기록을 되살릴 수 있어요. 이제 모두에게 사진이 보여요.';
const zhHans =
  '新增：用链接向任何人发起挑战。发出你的一分钟，每人一次机会来打破它。用六周计划和每周日的比赛战胜上周的自己。奖章全新改版：从青铜到钻石的 14 个奖章系列，把最好的三个展示在资料页。个人最佳和每个里程碑都有专属画面，每月回顾，本周好友超过你时会提醒你。看一段短视频可让胜利的 XP 翻倍或找回中断的连续记录。现在所有人都能看到照片。';
const zhHant =
  '新增：用連結向任何人發起挑戰。送出你的一分鐘，每人一次機會來打破它。用六週計畫和每週日的比賽戰勝上週的自己。獎章全新改版：從青銅到鑽石的 14 個獎章系列，把最好的三個展示在個人頁。個人最佳和每個里程碑都有專屬畫面，每月回顧，本週好友超過你時會提醒你。看一段短影片可讓勝利的 XP 加倍或找回中斷的連續紀錄。現在所有人都能看到照片。';
const hi =
  'नया: किसी को भी लिंक से चुनौती दो। अपना मिनट भेजो, हर किसी को उसे तोड़ने का एक मौका। छह हफ़्ते के प्लान और हर रविवार की रेस से पिछले हफ़्ते वाले खुद को हराओ। अवॉर्ड नए सिरे से: कांस्य से हीरा तक 14 मेडल परिवार, और अपने बेहतरीन तीन प्रोफ़ाइल पर। हर पर्सनल बेस्ट और हर माइलस्टोन की अपनी स्क्रीन, हर महीने का सार, और जब कोई दोस्त इस हफ़्ते आगे निकले तो सूचना। एक छोटा वीडियो जीत का XP दोगुना करता है या टूटी स्ट्रीक बचाता है। अब फ़ोटो सबको दिखती हैं।';
const id =
  'Baru: tantang siapa saja lewat link. Kirim menitmu, masing-masing punya satu kesempatan mengalahkannya. Kalahkan dirimu minggu lalu dengan rencana enam minggu dan balapan setiap Minggu. Penghargaan baru: 14 keluarga medali dari Perunggu sampai Berlian, dan tiga terbaikmu di profil. Layar khusus untuk rekor pribadi dan setiap pencapaian, rangkuman tiap bulan, dan pemberitahuan saat teman menyalipmu minggu ini. Video singkat menggandakan XP kemenangan atau menyelamatkan streak yang putus. Foto kini terlihat oleh semua orang.';

module.exports = {
  'en-US': en,
  'en-GB': en,
  'en-AU': en,
  'en-CA': en,
  'de-DE': de,
  'es-ES': es,
  'es-MX': es,
  'fr-FR': fr,
  'fr-CA': fr,
  it,
  'pt-BR': pt,
  'pt-PT': pt,
  ru,
  tr,
  ja,
  ko,
  'zh-Hans': zhHans,
  'zh-Hant': zhHant,
  hi,
  id,
  ms: en,
  ca: en,
  uk: en,
  'nl-NL': en,
  sv: en,
  no: en,
  da: en,
  fi: en,
  pl: en,
  cs: en,
  sk: en,
  hu: en,
  ro: en,
  hr: en,
  'sl-SI': en,
  el: en,
  th: en,
  vi: en,
  'ar-SA': en,
  he: en,
  'bn-BD': en,
  'ur-PK': en,
  'gu-IN': en,
  'kn-IN': en,
  'ml-IN': en,
  'mr-IN': en,
  'or-IN': en,
  'pa-IN': en,
  'ta-IN': en,
  'te-IN': en,
};
