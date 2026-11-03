// "What's New" for 1.1.6, every locale. The thirteen languages the app speaks
// get their own text; every other locale gets English, as the app itself
// shows English wherever it does not speak the language. Every claim is
// checked against lib/: a win is 25 rating plus the rep gap, a loss 20 plus
// it, the opponent does not count; the ranks strip is Week / Month / Overall.
// Nothing the store forbids: no prices, no "free".
const en =
  'New: a rating for every ranked match. A win adds 25 plus the gap in reps; a loss takes away 20 plus that gap. Ranks now show one strip for week, month and overall, and a board among your friends. A cleaner look across the app, bigger numbers on the live match, last month\'s winners, and you can now remove or crop your profile photo.';
const de =
  'Neu: eine Wertung für jedes Ranglisten-Match. Ein Sieg bringt 25 plus den Abstand in Wiederholungen, eine Niederlage kostet 20 plus diesen Abstand. Der Rang zeigt jetzt eine Leiste für Woche, Monat und Gesamt sowie eine Rangliste unter Freunden. Ein aufgeräumteres Design, größere Zahlen im Live-Match, die Gewinner des letzten Monats, und du kannst dein Profilfoto jetzt entfernen oder zuschneiden.';
const fr =
  "Nouveau : une cote pour chaque match classé. Une victoire rapporte 25 plus l'écart de répétitions, une défaite en coûte 20 plus cet écart. Le classement affiche désormais une seule bande pour la semaine, le mois et le total, plus un tableau entre amis. Un design plus épuré, des chiffres plus grands pendant le match en direct, les gagnants du mois dernier, et tu peux maintenant supprimer ou recadrer ta photo de profil.";
const es =
  'Novedades: una puntuación para cada partida clasificatoria. Una victoria da 25 más la diferencia de repeticiones; una derrota quita 20 más esa diferencia. La clasificación muestra ahora una sola franja para semana, mes y total, y una tabla entre amigos. Un diseño más limpio, números más grandes en la partida en directo, los ganadores del mes pasado, y ahora puedes quitar o recortar tu foto de perfil.';
const it =
  'Novità: un punteggio per ogni partita classificata. Una vittoria vale 25 più la differenza di ripetizioni; una sconfitta ne toglie 20 più quella differenza. La classifica mostra ora una sola striscia per settimana, mese e totale, più una tabella tra amici. Un aspetto più pulito, numeri più grandi nella partita dal vivo, i vincitori del mese scorso, e ora puoi rimuovere o ritagliare la foto del profilo.';
const pt =
  'Novidades: uma pontuação para cada partida ranqueada. Uma vitória dá 25 mais a diferença de repetições; uma derrota tira 20 mais essa diferença. O ranking agora mostra uma faixa só para a semana, o mês e o geral, além de um placar entre amigos. Visual mais limpo, números maiores na partida ao vivo, os campeões do mês passado, e agora você pode remover ou recortar a foto de perfil.';
const ru =
  'Новое: рейтинг за каждый матч в рейтинге. Победа даёт 25 плюс разницу в повторениях, поражение отнимает 20 плюс эту разницу. В рейтинге теперь одна полоса для недели, месяца и общего зачёта, а также таблица среди друзей. Более аккуратный вид, крупные цифры в матче, победители прошлого месяца, и теперь можно убрать или обрезать фото профиля.';
const tr =
  'Yeni: ranked her maç için bir puan. Galibiyet 25 artı tekrar farkı kazandırır; mağlubiyet 20 artı o farkı götürür. Sıralama artık hafta, ay ve genel için tek bir şerit gösteriyor, arkadaşlar arasında bir tablo da var. Daha sade bir görünüm, canlı maçta daha büyük sayılar, geçen ayın kazananları ve artık profil fotoğrafını kaldırabilir ya da kırpabilirsin.';
const ja =
  '新機能：ランク戦ごとにレーティング。勝つと25に回数の差を足し、負けると20に回数の差を足して減ります。ランキングは今週・今月・総合を1本のバーで表示し、フレンド内のランキングも追加。全体にすっきりしたデザイン、対戦画面の数字を大きく、先月の優勝者を表示、プロフィール写真を削除・トリミングできるようになりました。';
const ko =
  '새 기능: 랭크 매치마다 레이팅. 이기면 25점에 횟수 차이를 더하고, 지면 20점에 횟수 차이를 더해 빠집니다. 랭킹은 이제 주간·월간·전체를 하나의 막대로 보여주고, 친구들끼리의 순위도 있습니다. 전체적으로 더 깔끔한 디자인, 라이브 매치의 큰 숫자, 지난달 우승자, 그리고 프로필 사진을 지우거나 자를 수 있습니다.';
const zhHans =
  '新增：每场排位赛都有评分。赢一场得 25 分加上次数差，输一场扣 20 分加上次数差。排名现在用一条进度显示周、月和总榜，还有好友榜。整体界面更简洁，实时对战的数字更大，显示上月冠军，并且可以删除或裁剪头像。';
const zhHant =
  '新增：每場排位賽都有評分。贏一場得 25 分加上次數差，輸一場扣 20 分加上次數差。排名現在用一條進度顯示週、月和總榜，還有好友榜。整體介面更簡潔，即時對戰的數字更大，顯示上月冠軍，並且可以刪除或裁剪頭像。';
const hi =
  'नया: हर रैंक मैच पर रेटिंग। जीत पर 25 और रेप का अंतर जुड़ता है; हार पर 20 और वही अंतर घटता है। रैंकिंग में अब सप्ताह, महीने और कुल के लिए एक ही पट्टी है, और दोस्तों के बीच एक बोर्ड भी। पूरे ऐप का डिज़ाइन और साफ़, लाइव मैच में बड़े अंक, पिछले महीने के विजेता, और अब प्रोफ़ाइल फ़ोटो हटा या क्रॉप कर सकते हैं।';
const id =
  'Baru: rating untuk setiap pertandingan peringkat. Menang memberi 25 ditambah selisih repetisi; kalah mengurangi 20 ditambah selisih itu. Peringkat kini menampilkan satu strip untuk minggu, bulan, dan keseluruhan, serta papan di antara teman. Tampilan lebih rapi, angka lebih besar di pertandingan langsung, pemenang bulan lalu, dan foto profil bisa dihapus atau dipotong.';

module.exports = {
  'en-US': en,
  'en-GB': en,
  'en-AU': en,
  'en-CA': en,
  'de-DE': de,
  'fr-FR': fr,
  'fr-CA': fr,
  'es-ES': es,
  'es-MX': es,
  ca: en,
  it,
  'pt-BR': pt,
  'pt-PT': pt,
  ru,
  uk: en,
  tr,
  ja,
  ko,
  'zh-Hans': zhHans,
  'zh-Hant': zhHant,
  hi,
  id,
  ms: en,
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
