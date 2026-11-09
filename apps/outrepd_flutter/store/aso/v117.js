// Version 1.1.7 (2026-11-09): the full descriptions catch up with the app.
// "46 titles to earn" was the old list; the awards are now 14 families of
// five tiers plus three specials (lib/awards/families.dart, kAwardCount 73),
// three pinned to the profile (the Showcase), with a screen for each new best
// and milestone and a recap of each month (lib/moments.dart). Two sections
// are added: the six-week plan with a race against last week's best minute
// every Sunday (lib/plan.dart), after Adventure; and the challenge link, one
// try each, open seven days, its owner seeing every try (challenge.sql),
// after the friends. Tier words are the app's own (tierBronze, tierDiamond).
// The short descriptions of the other storefronts never named the titles and
// are left as they are. build.js applies this after ads_adventure.js.

const full = {
  en: {
    planHead: "BEAT LAST WEEK'S YOU",
    plan: 'A six-week plan built from your best minute, with sets for every training day. Every Sunday you race your own best minute from the week before.',
    linkHead: 'DARE ANYONE WITH A LINK',
    link: 'Send your best minute as a link. Whoever opens it races your set, one try each, and you see every result. The link stays open for seven days.',
    track: 'Your last ten results at a glance, every match by day, your best set and your streak. 73 awards in 14 medal families from Bronze to Diamond, with your best three pinned to your profile. A screen for every new personal best and milestone, and a recap of every month.',
  },
  de: {
    planHead: 'SCHLAG DICH VON LETZTER WOCHE',
    plan: 'Ein Sechs-Wochen-Plan aus deiner besten Minute, mit Sätzen für jeden Trainingstag. Jeden Sonntag trittst du gegen deine eigene beste Minute aus der Vorwoche an.',
    linkHead: 'FORDERE JEDEN PER LINK HERAUS',
    link: 'Schick deine beste Minute als Link. Wer ihn öffnet, tritt gegen deinen Satz an, ein Versuch pro Person, und du siehst jedes Ergebnis. Der Link bleibt sieben Tage offen.',
    track: 'Deine letzten zehn Ergebnisse auf einen Blick, jedes Match nach Tag, dein bester Satz und deine Serie. 73 Auszeichnungen in 14 Medaillen-Familien von Bronze bis Diamant, deine besten drei auf deinem Profil. Ein eigener Moment für jede neue Bestleistung und jeden Meilenstein und ein Rückblick auf jeden Monat.',
  },
  fr: {
    planHead: 'BATS TOI DE LA SEMAINE DERNIÈRE',
    plan: "Un plan de six semaines construit à partir de ta meilleure minute, avec des séries pour chaque jour d'entraînement. Chaque dimanche, tu affrontes ta propre meilleure minute de la semaine précédente.",
    linkHead: "DÉFIE N'IMPORTE QUI AVEC UN LIEN",
    link: "Envoie ta meilleure minute sous forme de lien. Qui l'ouvre affronte ta série, un essai chacun, et tu vois chaque résultat. Le lien reste ouvert sept jours.",
    track: "Tes dix derniers résultats d'un coup d'œil, chaque match par jour, ta meilleure série et ta série de jours. 73 récompenses en 14 familles de médailles, du Bronze au Diamant, et tes trois meilleures sur ton profil. Un écran pour chaque record perso et chaque cap, et un bilan de chaque mois.",
  },
  es: {
    planHead: 'SUPERA A TU YO DE LA SEMANA PASADA',
    plan: 'Un plan de seis semanas a partir de tu mejor minuto, con series para cada día de entrenamiento. Cada domingo compites contra tu propio mejor minuto de la semana anterior.',
    linkHead: 'RETA A QUIEN QUIERAS CON UN ENLACE',
    link: 'Envía tu mejor minuto como enlace. Quien lo abre compite contra tu serie, un intento cada uno, y ves cada resultado. El enlace sigue abierto siete días.',
    track: 'Tus diez últimos resultados de un vistazo, cada partida por día, tu mejor serie y tu racha. 73 premios en 14 familias de medallas, de Bronce a Diamante, y tus tres mejores en tu perfil. Una pantalla para cada récord personal y cada hito, y un resumen de cada mes.',
  },
  it: {
    planHead: 'BATTI IL TE DELLA SETTIMANA SCORSA',
    plan: 'Un piano di sei settimane costruito sul tuo minuto migliore, con le serie per ogni giorno di allenamento. Ogni domenica sfidi il tuo minuto migliore della settimana prima.',
    linkHead: 'SFIDA CHIUNQUE CON UN LINK',
    link: 'Manda il tuo minuto migliore come link. Chi lo apre affronta la tua serie, un tentativo a testa, e vedi ogni risultato. Il link resta aperto sette giorni.',
    track: "I tuoi ultimi dieci risultati a colpo d'occhio, ogni partita per giorno, la tua serie migliore e la tua striscia. 73 premi in 14 famiglie di medaglie dal Bronzo al Diamante, con le tue tre migliori sul profilo. Una schermata per ogni record personale e ogni traguardo, e un riepilogo di ogni mese.",
  },
  pt: {
    planHead: 'VENÇA VOCÊ DA SEMANA PASSADA',
    plan: 'Um plano de seis semanas feito a partir do seu melhor minuto, com séries para cada dia de treino. Todo domingo você enfrenta o seu próprio melhor minuto da semana anterior.',
    linkHead: 'DESAFIE QUALQUER PESSOA COM UM LINK',
    link: 'Envie seu melhor minuto como link. Quem abrir enfrenta a sua série, uma tentativa cada um, e você vê cada resultado. O link fica aberto por sete dias.',
    track: 'Seus dez últimos resultados de relance, cada partida por dia, sua melhor série e sua sequência. 73 prêmios em 14 famílias de medalhas, do Bronze ao Diamante, e as suas três melhores no perfil. Uma tela para cada recorde pessoal e cada marco, e um resumo de cada mês.',
  },
  ru: {
    planHead: 'ПОБЕДИ СЕБЯ ПРОШЛОЙ НЕДЕЛИ',
    plan: 'Шестинедельный план на основе твоей лучшей минуты, с подходами на каждый тренировочный день. Каждое воскресенье ты соревнуешься со своей лучшей минутой прошлой недели.',
    linkHead: 'БРОСАЙ ВЫЗОВ ПО ССЫЛКЕ',
    link: 'Отправь свою лучшую минуту ссылкой. Кто её откроет, соревнуется с твоим подходом, по одной попытке на каждого, а ты видишь каждый результат. Ссылка открыта семь дней.',
    track: 'Последние десять результатов одним взглядом, каждый матч по дням, лучший подход и серия. 73 награды в 14 семействах медалей от бронзы до алмаза, три лучшие — в твоём профиле. Отдельный экран для каждого личного рекорда и рубежа и итоги каждого месяца.',
  },
  tr: {
    planHead: 'GEÇEN HAFTAKİ SENİ YEN',
    plan: 'En iyi dakikandan kurulan altı haftalık bir plan, her antrenman günü için setlerle. Her pazar, bir önceki haftadaki kendi en iyi dakikanla yarışırsın.',
    linkHead: 'HERKESE BİR BAĞLANTIYLA MEYDAN OKU',
    link: 'En iyi dakikanı bağlantı olarak gönder. Onu açan herkes senin setinle yarışır, herkese bir hak, ve her sonucu görürsün. Bağlantı yedi gün açık kalır.',
    track: 'Son on sonucun bir bakışta, her maç güne göre, en iyi setin ve serin. Bronzdan Elmasa 14 madalya ailesinde 73 ödül, en iyi üçün profilinde. Her kişisel rekor ve her eşik için ayrı ekran ve her ayın özeti.',
  },
  ja: {
    planHead: '先週の自分に勝て',
    plan: 'あなたのベスト1分から作る6週間プラン。トレーニング日ごとのセットつき。毎週日曜は、前の週の自分のベスト1分とレース。',
    linkHead: 'リンクで誰にでも挑戦',
    link: 'ベスト1分をリンクで送ろう。開いた人はあなたのセットに1人1回挑戦でき、結果はすべて見られます。リンクは7日間有効。',
    track: '直近10試合の結果がひと目で分かり、試合は日ごとに一覧に。ベストセットと連続記録も。ブロンズからダイヤモンドまで14系統・73個のアワード、ベスト3はプロフィールに。自己ベストや節目ごとの専用画面と、毎月のまとめ。',
  },
  ko: {
    planHead: '지난주의 나를 이겨라',
    plan: '내 최고 1분을 바탕으로 만든 6주 플랜, 훈련일마다 세트가 정해져 있어요. 매주 일요일에는 지난주 나의 최고 1분과 레이스.',
    linkHead: '링크로 누구에게나 도전',
    link: '최고 1분을 링크로 보내세요. 링크를 연 사람은 한 번씩 내 세트에 도전하고, 나는 모든 결과를 볼 수 있어요. 링크는 7일 동안 열려 있어요.',
    track: '최근 10경기 결과를 한눈에, 모든 경기를 날짜별로, 최고 기록과 연속 기록. 브론즈부터 다이아몬드까지 14개 메달 계열의 어워드 73개, 최고의 3개는 프로필에. 개인 최고 기록과 마일스톤마다 전용 화면, 그리고 매달의 요약.',
  },
  zhHans: {
    planHead: '战胜上周的自己',
    plan: '根据你的最佳一分钟制定的六周计划，每个训练日都有安排好的组数。每周日，和你自己上一周的最佳一分钟比赛。',
    linkHead: '用链接向任何人发起挑战',
    link: '把你的最佳一分钟作为链接发出去。打开链接的人来挑战你的这一组，每人一次机会，每个结果你都能看到。链接开放七天。',
    track: '最近十场结果一目了然，每场比赛按日期排列，还有你的最佳一组和连续记录。从青铜到钻石的 14 个奖章系列共 73 枚奖章，最好的三枚展示在你的资料页。每个个人最佳和里程碑都有专属画面，还有每月回顾。',
  },
  zhHant: {
    planHead: '戰勝上週的自己',
    plan: '根據你的最佳一分鐘制定的六週計畫，每個訓練日都有安排好的組數。每週日，和你自己上一週的最佳一分鐘比賽。',
    linkHead: '用連結向任何人發起挑戰',
    link: '把你的最佳一分鐘做成連結送出去。打開連結的人來挑戰你的這一組，每人一次機會，每個結果你都看得到。連結開放七天。',
    track: '最近十場結果一目了然，每場比賽按日期排列，還有你的最佳一組和連續紀錄。從青銅到鑽石的 14 個獎章系列共 73 枚獎章，最好的三枚展示在你的個人頁。每個個人最佳和里程碑都有專屬畫面，還有每月回顧。',
  },
  hi: {
    planHead: 'पिछले हफ़्ते वाले खुद को हराइए',
    plan: 'आपके सबसे अच्छे मिनट से बना छह हफ़्ते का प्लान, हर ट्रेनिंग दिन के सेट के साथ। हर रविवार आप पिछले हफ़्ते के अपने सबसे अच्छे मिनट से रेस करते हैं।',
    linkHead: 'किसी को भी लिंक से चुनौती दीजिए',
    link: 'अपना सबसे अच्छा मिनट लिंक के रूप में भेजिए। जो भी उसे खोले, वह आपके सेट से मुकाबला करता है, हर किसी को एक मौका, और आप हर नतीजा देखते हैं। लिंक सात दिन खुला रहता है।',
    track: 'पिछले दस नतीजे एक नज़र में, हर मैच दिन के हिसाब से, आपका सबसे अच्छा सेट और आपकी स्ट्रीक। कांस्य से हीरा तक 14 मेडल परिवारों में 73 अवॉर्ड, और आपके बेहतरीन तीन आपकी प्रोफ़ाइल पर। हर पर्सनल बेस्ट और हर माइलस्टोन की अपनी स्क्रीन, और हर महीने का सार।',
  },
  id: {
    planHead: 'KALAHKAN DIRIMU MINGGU LALU',
    plan: 'Rencana enam minggu yang dibuat dari menit terbaikmu, dengan set untuk setiap hari latihan. Setiap Minggu kamu balapan melawan menit terbaikmu sendiri dari minggu sebelumnya.',
    linkHead: 'TANTANG SIAPA SAJA LEWAT LINK',
    link: 'Kirim menit terbaikmu sebagai link. Siapa pun yang membukanya melawan set-mu, masing-masing satu kesempatan, dan kamu melihat setiap hasilnya. Link tetap terbuka tujuh hari.',
    track: 'Sepuluh hasil terakhir dalam sekilas, setiap pertandingan per hari, set terbaikmu dan streak-mu. 73 penghargaan dalam 14 keluarga medali dari Perunggu sampai Berlian, dan tiga terbaikmu di profil. Layar khusus untuk setiap rekor pribadi dan pencapaian, dan rangkuman tiap bulan.',
  },
};
// Portugal: "ecrã", not "tela"; "todos os domingos".
full.ptPT = {
  ...full.pt,
  plan: full.pt.plan.replace('Todo domingo', 'Todos os domingos'),
  track: full.pt.track.replace('Uma tela', 'Um ecrã'),
};

const fullFor = {
  'en-US': full.en, 'en-GB': full.en, 'en-AU': full.en, 'en-CA': full.en,
  'de-DE': full.de, 'fr-FR': full.fr, 'fr-CA': full.fr, 'es-ES': full.es, 'es-MX': full.es,
  it: full.it, 'pt-BR': full.pt, 'pt-PT': full.ptPT, ru: full.ru, tr: full.tr, ja: full.ja,
  ko: full.ko, 'zh-Hans': full.zhHans, 'zh-Hant': full.zhHant, hi: full.hi, id: full.id,
};

function apply(locales) {
  for (const [locale, x] of Object.entries(locales)) {
    const f = fullFor[locale];
    if (!f) continue;
    const parts = x.description.split('\n\n');
    if (parts.length !== 13) throw new Error(`${locale}: not the full shape after ads_adventure`);
    // After Adventure (put at 5 by ads_adventure.js): the plan.
    parts.splice(6, 0, `${f.planHead}\n${f.plan}`);
    // The progress paragraph is the one that counted 46 titles.
    const t = parts.findIndex((p) => /46/.test(p));
    if (t < 0) throw new Error(`${locale}: no progress paragraph`);
    const lines = parts[t].split('\n');
    if (lines.length !== 2) throw new Error(`${locale}: progress paragraph shape`);
    parts[t] = `${lines[0]}\n${f.track}`;
    // Right before it, after the friends: the challenge link.
    parts.splice(t, 0, `${f.linkHead}\n${f.link}`);
    locales[locale] = { ...x, description: parts.join('\n\n') };
  }
  return locales;
}

module.exports = { apply };
