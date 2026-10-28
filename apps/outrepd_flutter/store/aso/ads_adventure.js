// Version 1.1.5 (2026-10-28): the app is free to play with ads, OUTREPD Pro
// removes them, and Adventure replaced Practice. Every description said
// "OUTREPD needs a subscription"; this replaces that first sentence of the
// subscription paragraph (its heading too, where there is one), keeps the
// renewal terms after it as they were, and adds Adventure after the ranks.
// The app's own languages name the mode as the app does; the others keep the
// English "Adventure", as they keep the English tier names. build.js applies
// it. Nothing here says "free": build.js still refuses pricing words.

// The twelve languages the app speaks, and English: a section each.
const full = {
  en: {
    advHead: 'ADVENTURE',
    adv: '140 push-up fights across seven worlds, from Iron to Master. Every rep hits the monster, and the monsters evolve as you go. Win stars to unlock the weapon each new world needs. No rank on the line, and it works offline.',
    proHead: 'ADS AND OUTREPD PRO',
    pro: 'Every mode can be played without a subscription, and an ad plays when you leave the result of a game. OUTREPD Pro, a weekly or yearly subscription, removes the ads.',
  },
  de: {
    advHead: 'ABENTEUER',
    adv: '140 Liegestütz-Kämpfe in sieben Welten, von Eisen bis Meister. Jede Wiederholung trifft das Monster, und die Monster entwickeln sich mit jeder Welt weiter. Sammle Sterne für die Waffe, die jede neue Welt verlangt. Kein Rang steht auf dem Spiel, und es geht auch offline.',
    proHead: 'WERBUNG UND OUTREPD PRO',
    pro: 'Jeder Modus lässt sich ohne Abonnement spielen; wenn du das Ergebnis eines Spiels verlässt, läuft eine Werbung. OUTREPD Pro, ein wöchentliches oder jährliches Abonnement, entfernt die Werbung.',
  },
  fr: {
    advHead: 'AVENTURE',
    adv: '140 combats de pompes dans sept mondes, de Fer à Maître. Chaque répétition frappe le monstre, et les monstres évoluent au fil du jeu. Gagne des étoiles pour débloquer l’arme qu’exige chaque nouveau monde. Aucun rang en jeu, et ça marche hors ligne.',
    proHead: 'PUBLICITÉS ET OUTREPD PRO',
    pro: 'Tous les modes se jouent sans abonnement, et une publicité passe quand tu quittes le résultat d’une partie. OUTREPD Pro, un abonnement hebdomadaire ou annuel, retire les publicités.',
  },
  es: {
    advHead: 'AVENTURA',
    adv: '140 combates de flexiones en siete mundos, de Hierro a Maestro. Cada repetición golpea al monstruo, y los monstruos evolucionan a medida que avanzas. Gana estrellas para desbloquear el arma que pide cada mundo nuevo. No te juegas el rango, y funciona sin conexión.',
    proHead: 'ANUNCIOS Y OUTREPD PRO',
    pro: 'Todos los modos se pueden jugar sin suscripción, y sale un anuncio al salir del resultado de una partida. OUTREPD Pro, una suscripción semanal o anual, quita los anuncios.',
  },
  esMX: {
    advHead: 'AVENTURA',
    adv: '140 combates de lagartijas en siete mundos, de Hierro a Maestro. Cada repetición golpea al monstruo, y los monstruos evolucionan a medida que avanzas. Gana estrellas para desbloquear el arma que pide cada mundo nuevo. No te juegas el rango, y funciona sin conexión.',
    proHead: 'ANUNCIOS Y OUTREPD PRO',
    pro: 'Todos los modos se pueden jugar sin suscripción, y sale un anuncio al salir del resultado de una partida. OUTREPD Pro, una suscripción semanal o anual, quita los anuncios.',
  },
  it: {
    advHead: 'AVVENTURA',
    adv: '140 combattimenti a flessioni in sette mondi, da Ferro a Maestro. Ogni ripetizione colpisce il mostro, e i mostri si evolvono man mano che avanzi. Guadagna stelle per sbloccare l’arma che serve a ogni nuovo mondo. Nessun grado in gioco, e funziona offline.',
    proHead: 'PUBBLICITÀ E OUTREPD PRO',
    pro: 'Ogni modalità si gioca senza abbonamento, e parte una pubblicità quando lasci il risultato di una partita. OUTREPD Pro, un abbonamento settimanale o annuale, toglie la pubblicità.',
  },
  pt: {
    advHead: 'AVENTURA',
    adv: '140 lutas de flexões em sete mundos, do Ferro ao Mestre. Cada repetição acerta o monstro, e os monstros evoluem conforme você avança. Ganhe estrelas para desbloquear a arma que cada novo mundo exige. Nenhum ranking em jogo, e funciona offline.',
    proHead: 'ANÚNCIOS E OUTREPD PRO',
    pro: 'Todos os modos podem ser jogados sem assinatura, e um anúncio aparece quando você sai do resultado de uma partida. O OUTREPD Pro, uma assinatura semanal ou anual, remove os anúncios.',
  },
  ru: {
    advHead: 'ПРИКЛЮЧЕНИЕ',
    adv: '140 боёв на отжиманиях в семи мирах, от Железа до Мастера. Каждое повторение бьёт монстра, а монстры эволюционируют по ходу игры. Зарабатывай звёзды на оружие — без него в новый мир не пройти. Рейтинг не на кону, и всё работает офлайн.',
    proHead: 'РЕКЛАМА И OUTREPD PRO',
    pro: 'Во всех режимах можно играть без подписки; когда ты уходишь с экрана результата, показывается реклама. OUTREPD Pro — недельная или годовая подписка — убирает рекламу.',
  },
  tr: {
    advHead: 'MACERA',
    adv: 'Demir’den Usta’ya yedi dünyada 140 şınav dövüşü. Her tekrar canavara vurur ve canavarlar ilerledikçe evrimleşir. Her yeni dünyanın istediği silahı açmak için yıldız kazan. Rütben tehlikede değil ve çevrimdışı da çalışır.',
    proHead: 'REKLAMLAR VE OUTREPD PRO',
    pro: 'Tüm modlar abonelik olmadan oynanabilir; bir oyunun sonucundan çıkarken reklam gösterilir. Haftalık veya yıllık bir abonelik olan OUTREPD Pro reklamları kaldırır.',
  },
  ja: {
    advHead: 'アドベンチャー',
    adv: 'アイアンからマスターまで、7つのワールドで140の腕立て伏せバトル。1回ごとにモンスターにダメージを与え、モンスターは先へ進むほど進化します。星を集めて、新しいワールドに必要な武器をアンロック。ランクは変動せず、オフラインでも遊べます。',
    proHead: '広告とOUTREPD Pro',
    pro: 'すべてのモードはサブスクリプションなしで遊べます。試合の結果画面を離れるときに広告が表示されます。週間または年間のサブスクリプション「OUTREPD Pro」で広告を非表示にできます。',
  },
  ko: {
    advHead: '어드벤처',
    adv: '아이언부터 마스터까지, 7개 월드에서 펼치는 140번의 팔굽혀펴기 전투. 한 번 할 때마다 몬스터를 공격하고, 몬스터는 갈수록 진화합니다. 별을 모아 새 월드마다 필요한 무기를 잠금 해제하세요. 랭크는 걸려 있지 않으며 오프라인에서도 플레이할 수 있습니다.',
    proHead: '광고와 OUTREPD Pro',
    pro: '모든 모드는 구독 없이 플레이할 수 있으며, 게임 결과 화면을 나갈 때 광고가 나옵니다. 주간 또는 연간 구독인 OUTREPD Pro로 광고를 없앨 수 있습니다.',
  },
  zhHans: {
    advHead: '冒险',
    adv: '从黑铁到大师，七个世界，140 场俯卧撑战斗。每做一次都会击中怪物，怪物也会随着进度不断进化。收集星星，解锁每个新世界所需的武器。不影响排位，离线也能玩。',
    proHead: '广告与 OUTREPD Pro',
    pro: '所有模式都无需订阅即可游玩；离开对局结果页时会播放一条广告。OUTREPD Pro（按周或按年订阅）可去除广告。',
  },
  zhHant: {
    advHead: '冒險',
    adv: '從黑鐵到大師，七個世界，140 場伏地挺身戰鬥。每做一下都會擊中怪物，怪物也會隨著進度不斷進化。收集星星，解鎖每個新世界所需的武器。不影響排位，離線也能玩。',
    proHead: '廣告與 OUTREPD Pro',
    pro: '所有模式都不需訂閱即可遊玩；離開對局結果頁時會播放一則廣告。OUTREPD Pro（按週或按年訂閱）可移除廣告。',
  },
  hi: {
    advHead: 'एडवेंचर',
    adv: 'लोहा से मास्टर तक, सात दुनियाओं में 140 पुश-अप लड़ाइयाँ। हर रेप मॉन्स्टर पर वार करता है, और आगे बढ़ते-बढ़ते मॉन्स्टर बदलकर और ताकतवर होते जाते हैं। स्टार जीतकर वो हथियार अनलॉक कीजिए जो हर नई दुनिया के लिए ज़रूरी है। रैंक दाँव पर नहीं होती, और यह ऑफ़लाइन भी चलता है।',
    proHead: 'विज्ञापन और OUTREPD Pro',
    pro: 'हर मोड बिना सब्सक्रिप्शन के खेला जा सकता है; किसी गेम का नतीजा छोड़ते समय एक विज्ञापन चलता है। OUTREPD Pro, एक साप्ताहिक या वार्षिक सब्सक्रिप्शन, विज्ञापन हटा देता है।',
  },
  id: {
    advHead: 'PETUALANGAN',
    adv: '140 pertarungan push up di tujuh dunia, dari Besi sampai Master. Setiap repetisi memukul monster, dan monsternya berevolusi seiring kamu maju. Kumpulkan bintang untuk membuka senjata yang dibutuhkan setiap dunia baru. Peringkat tidak dipertaruhkan, dan bisa dimainkan offline.',
    proHead: 'IKLAN DAN OUTREPD PRO',
    pro: 'Semua mode bisa dimainkan tanpa langganan, dan iklan diputar saat kamu meninggalkan hasil permainan. OUTREPD Pro, langganan mingguan atau tahunan, menghapus iklan.',
  },
};
const fullFor = {
  'en-US': full.en, 'en-GB': full.en, 'en-AU': full.en, 'en-CA': full.en,
  'de-DE': full.de, 'fr-FR': full.fr, 'fr-CA': full.fr, 'es-ES': full.es, 'es-MX': full.esMX,
  it: full.it, 'pt-BR': full.pt, 'pt-PT': full.pt, ru: full.ru, tr: full.tr, ja: full.ja,
  ko: full.ko, 'zh-Hans': full.zhHans, 'zh-Hant': full.zhHant, hi: full.hi, id: full.id,
};

// The storefront languages the app does not speak: a sentence each.
// [old] only where the first sentence has no stop to find it by.
const short = {
  ca: { adv: 'Adventure: 140 combats de flexions en set mons, amb monstres que evolucionen i armes per desbloquejar. Sense rang en joc.', pro: 'Tots els modes es poden jugar sense subscripció, i surt un anunci després de cada partida. OUTREPD Pro, una subscripció setmanal o anual, treu els anuncis.' },
  'nl-NL': { adv: 'Adventure: 140 push-upgevechten in zeven werelden, met monsters die evolueren en wapens om vrij te spelen. Je rang staat niet op het spel.', pro: 'Elke modus is te spelen zonder abonnement; na een spel komt er een advertentie. OUTREPD Pro, een wekelijks of jaarlijks abonnement, haalt de advertenties weg.' },
  sv: { adv: 'Adventure: 140 armhävningsstrider i sju världar, med monster som utvecklas och vapen att låsa upp. Ingen ranking står på spel.', pro: 'Alla lägen kan spelas utan prenumeration, och en annons visas efter en match. OUTREPD Pro, en vecko- eller årsprenumeration, tar bort annonserna.' },
  no: { adv: 'Adventure: 140 armhevingskamper i sju verdener, med monstre som utvikler seg og våpen å låse opp. Rangeringen din står ikke på spill.', pro: 'Alle moduser kan spilles uten abonnement, og en annonse vises etter en kamp. OUTREPD Pro, et ukentlig eller årlig abonnement, fjerner annonsene.' },
  da: { adv: 'Adventure: 140 armstrækningskampe i syv verdener, med monstre, der udvikler sig, og våben, der skal låses op. Din rangering er ikke på spil.', pro: 'Alle tilstande kan spilles uden abonnement, og der vises en reklame efter en kamp. OUTREPD Pro, et ugentligt eller årligt abonnement, fjerner reklamerne.' },
  fi: { adv: 'Adventure: 140 punnerrustaistelua seitsemässä maailmassa, kehittyviä hirviöitä ja avattavia aseita. Rankingisi ei ole pelissä.', pro: 'Kaikkia tiloja voi pelata ilman tilausta, ja pelin jälkeen näytetään mainos. OUTREPD Pro, viikko- tai vuositilaus, poistaa mainokset.' },
  pl: { adv: 'Adventure: 140 walk na pompki w siedmiu światach, z potworami, które ewoluują, i bronią do odblokowania. Ranking nie jest stawką.', pro: 'W każdym trybie można grać bez subskrypcji, a po grze wyświetla się reklama. OUTREPD Pro, subskrypcja tygodniowa lub roczna, usuwa reklamy.' },
  cs: { adv: 'Adventure: 140 soubojů v klicích v sedmi světech, s příšerami, které se vyvíjejí, a se zbraněmi k odemčení. O hodnocení se nehraje.', pro: 'Všechny režimy lze hrát bez předplatného a po hře se zobrazí reklama. OUTREPD Pro, týdenní nebo roční předplatné, reklamy odstraní.' },
  sk: { adv: 'Adventure: 140 súbojov v klikoch v siedmich svetoch, s príšerami, ktoré sa vyvíjajú, a so zbraňami na odomknutie. O hodnotenie sa nehrá.', pro: 'Všetky režimy sa dajú hrať bez predplatného a po hre sa zobrazí reklama. OUTREPD Pro, týždenné alebo ročné predplatné, reklamy odstráni.' },
  hu: { adv: 'Adventure: 140 fekvőtámasz-csata hét világban, fejlődő szörnyekkel és feloldható fegyverekkel. A rangod nincs veszélyben.', pro: 'Minden mód előfizetés nélkül játszható, és egy játék után reklám jelenik meg. Az OUTREPD Pro, egy heti vagy éves előfizetés, eltávolítja a reklámokat.' },
  ro: { adv: 'Adventure: 140 de lupte cu flotări în șapte lumi, cu monștri care evoluează și arme de deblocat. Rangul nu e în joc.', pro: 'Toate modurile se pot juca fără abonament, iar după un joc apare o reclamă. OUTREPD Pro, un abonament săptămânal sau anual, elimină reclamele.' },
  hr: { adv: 'Adventure: 140 borbi sklekovima u sedam svjetova, s čudovištima koja se razvijaju i oružjem za otključavanje. Rang nije u igri.', pro: 'Svi se načini mogu igrati bez pretplate, a nakon igre prikazuje se oglas. OUTREPD Pro, tjedna ili godišnja pretplata, uklanja oglase.' },
  'sl-SI': { adv: 'Adventure: 140 bojev s sklecami v sedmih svetovih, s pošastmi, ki se razvijajo, in orožjem za odklepanje. Uvrstitev ni na kocki.', pro: 'Vsi načini so na voljo brez naročnine, po igri pa se prikaže oglas. OUTREPD Pro, tedenska ali letna naročnina, odstrani oglase.' },
  el: { adv: 'Adventure: 140 μάχες με κάμψεις σε επτά κόσμους, με τέρατα που εξελίσσονται και όπλα για ξεκλείδωμα. Η κατάταξή σου δεν παίζεται.', pro: 'Όλες οι λειτουργίες παίζονται χωρίς συνδρομή, και μετά από κάθε παιχνίδι εμφανίζεται μια διαφήμιση. Το OUTREPD Pro, εβδομαδιαία ή ετήσια συνδρομή, αφαιρεί τις διαφημίσεις.' },
  uk: { adv: 'Adventure: 140 боїв на віджиманнях у семи світах, з монстрами, що еволюціонують, і зброєю, яку треба відкрити. Рейтинг не на кону.', pro: 'У всі режими можна грати без підписки, а після гри показується реклама. OUTREPD Pro — тижнева або річна підписка — прибирає рекламу.' },
  th: { old: 'OUTREPD ต้องสมัครสมาชิกแบบรายสัปดาห์หรือรายปี', adv: 'Adventure: การต่อสู้ด้วยวิดพื้น 140 ด่านใน 7 โลก พร้อมมอนสเตอร์ที่วิวัฒนาการและอาวุธให้ปลดล็อก ไม่กระทบอันดับ', pro: 'ทุกโหมดเล่นได้โดยไม่ต้องสมัครสมาชิก และจะมีโฆษณาหลังจบเกม OUTREPD Pro แบบรายสัปดาห์หรือรายปีจะเอาโฆษณาออก' },
  vi: { adv: 'Adventure: 140 trận chiến hít đất qua bảy thế giới, với quái vật tiến hóa và vũ khí để mở khóa. Không ảnh hưởng thứ hạng.', pro: 'Mọi chế độ đều chơi được mà không cần gói đăng ký, và sẽ có quảng cáo sau mỗi trận. OUTREPD Pro, gói đăng ký theo tuần hoặc theo năm, sẽ gỡ bỏ quảng cáo.' },
  ms: { adv: 'Adventure: 140 pertarungan tekan tubi dalam tujuh dunia, dengan raksasa yang berevolusi dan senjata untuk dibuka. Ranking anda tidak dipertaruhkan.', pro: 'Semua mod boleh dimainkan tanpa langganan, dan iklan dipaparkan selepas permainan. OUTREPD Pro, langganan mingguan atau tahunan, membuang iklan.' },
  'ar-SA': { adv: 'وضع Adventure: ‏140 معركة ضغط في سبعة عوالم، مع وحوش تتطور وأسلحة تفتحها. لا يتأثر تصنيفك.', pro: 'يمكن لعب كل الأوضاع بدون اشتراك، ويظهر إعلان بعد انتهاء اللعبة. ويزيل OUTREPD Pro، وهو اشتراك أسبوعي أو سنوي، الإعلانات.' },
  he: { adv: 'Adventure: ‏140 קרבות שכיבות סמיכה בשבעה עולמות, עם מפלצות שמתפתחות ונשקים לפתוח. הדירוג שלך לא בסכנה.', pro: 'אפשר לשחק בכל המצבים בלי מינוי, ואחרי משחק מוצגת פרסומת. OUTREPD Pro, מינוי שבועי או שנתי, מסיר את הפרסומות.' },
  'bn-BD': { adv: 'Adventure: সাতটি জগতে 140টি পুশ-আপ লড়াই, সাথে বিবর্তিত হওয়া দানব আর আনলক করার মতো অস্ত্র। র‍্যাঙ্ক ঝুঁকিতে থাকে না।', pro: 'প্রতিটি মোড সাবস্ক্রিপশন ছাড়াই খেলা যায়, আর খেলা শেষে একটি বিজ্ঞাপন দেখানো হয়। OUTREPD Pro, একটি সাপ্তাহিক বা বার্ষিক সাবস্ক্রিপশন, বিজ্ঞাপন সরিয়ে দেয়।' },
  'ur-PK': { adv: 'Adventure: سات دنیاؤں میں 140 پش اپ لڑائیاں، بدلتے ہوئے راکشسوں اور کھولنے کے لیے ہتھیاروں کے ساتھ۔ آپ کی رینک داؤ پر نہیں ہوتی۔', pro: 'ہر موڈ سبسکرپشن کے بغیر کھیلا جا سکتا ہے، اور گیم کے بعد ایک اشتہار چلتا ہے۔ OUTREPD Pro، ایک ہفتہ وار یا سالانہ سبسکرپشن، اشتہار ہٹا دیتا ہے۔' },
  'gu-IN': { adv: 'Adventure: સાત દુનિયામાં 140 પુશ-અપ લડાઈઓ, વિકસતા રાક્ષસો અને અનલૉક કરવા માટેનાં હથિયારો સાથે. તમારી રેન્ક દાવ પર નથી.', pro: 'દરેક મોડ સબ્સ્ક્રિપ્શન વિના રમી શકાય છે, અને ગેમ પછી એક જાહેરાત આવે છે. OUTREPD Pro, સાપ્તાહિક અથવા વાર્ષિક સબ્સ્ક્રિપ્શન, જાહેરાતો દૂર કરે છે.' },
  'kn-IN': { adv: 'Adventure: ಏಳು ಲೋಕಗಳಲ್ಲಿ 140 ಪುಷ್-ಅಪ್ ಹೋರಾಟಗಳು, ವಿಕಸನಗೊಳ್ಳುವ ರಾಕ್ಷಸರು ಮತ್ತು ಅನ್‌ಲಾಕ್ ಮಾಡಬೇಕಾದ ಆಯುಧಗಳೊಂದಿಗೆ. ನಿಮ್ಮ ರ‍್ಯಾಂಕ್ ಪಣಕ್ಕಿಲ್ಲ.', pro: 'ಪ್ರತಿ ಮೋಡ್ ಅನ್ನು ಚಂದಾದಾರಿಕೆ ಇಲ್ಲದೆ ಆಡಬಹುದು, ಮತ್ತು ಆಟದ ನಂತರ ಒಂದು ಜಾಹೀರಾತು ಬರುತ್ತದೆ. ವಾರದ ಅಥವಾ ವಾರ್ಷಿಕ ಚಂದಾದಾರಿಕೆಯಾದ OUTREPD Pro ಜಾಹೀರಾತುಗಳನ್ನು ತೆಗೆದುಹಾಕುತ್ತದೆ.' },
  'ml-IN': { adv: 'Adventure: ഏഴ് ലോകങ്ങളിലായി 140 പുഷ്-അപ്പ് പോരാട്ടങ്ങൾ, പരിണമിക്കുന്ന രാക്ഷസരും അൺലോക്ക് ചെയ്യാനുള്ള ആയുധങ്ങളും. നിങ്ങളുടെ റാങ്ക് അപകടത്തിലല്ല.', pro: 'എല്ലാ മോഡുകളും സബ്സ്ക്രിപ്ഷൻ ഇല്ലാതെ കളിക്കാം, ഓരോ ഗെയിമിനും ശേഷം ഒരു പരസ്യം വരും. പ്രതിവാര അല്ലെങ്കിൽ വാർഷിക സബ്സ്ക്രിപ്ഷനായ OUTREPD Pro പരസ്യങ്ങൾ നീക്കം ചെയ്യുന്നു.' },
  'mr-IN': { adv: 'Adventure: सात जगांमध्ये 140 पुश-अप लढाया, उत्क्रांत होणारे राक्षस आणि अनलॉक करायची शस्त्रे यांसह. तुमची रँक पणाला लागत नाही.', pro: 'प्रत्येक मोड सबस्क्रिप्शनशिवाय खेळता येतो, आणि गेमनंतर एक जाहिरात दिसते. OUTREPD Pro, साप्ताहिक किंवा वार्षिक सबस्क्रिप्शन, जाहिराती काढून टाकते.' },
  'or-IN': { adv: 'Adventure: ସାତଟି ଦୁନିଆରେ 140ଟି ପୁଶ-ଅପ୍ ଲଢ଼େଇ, ବିକଶିତ ହେଉଥିବା ରାକ୍ଷସ ଓ ଅନଲକ୍ କରିବାକୁ ଅସ୍ତ୍ର ସହ। ଆପଣଙ୍କ ର୍ୟାଙ୍କ ବାଜିରେ ନାହିଁ।', pro: 'ପ୍ରତ୍ୟେକ ମୋଡ୍ ସବସ୍କ୍ରିପସନ୍ ବିନା ଖେଳିହେବ, ଏବଂ ଖେଳ ପରେ ଗୋଟିଏ ବିଜ୍ଞାପନ ଆସେ। OUTREPD Pro, ସାପ୍ତାହିକ କିମ୍ବା ବାର୍ଷିକ ସବସ୍କ୍ରିପସନ୍, ବିଜ୍ଞାପନ ହଟାଇଦିଏ।' },
  'pa-IN': { adv: 'Adventure: ਸੱਤ ਦੁਨੀਆਂ ਵਿੱਚ 140 ਪੁਸ਼-ਅੱਪ ਲੜਾਈਆਂ, ਵਿਕਸਿਤ ਹੁੰਦੇ ਰਾਖਸ਼ਾਂ ਅਤੇ ਅਨਲੌਕ ਕਰਨ ਵਾਲੇ ਹਥਿਆਰਾਂ ਨਾਲ। ਤੁਹਾਡਾ ਰੈਂਕ ਦਾਅ ’ਤੇ ਨਹੀਂ।', pro: 'ਹਰ ਮੋਡ ਸਬਸਕ੍ਰਿਪਸ਼ਨ ਤੋਂ ਬਿਨਾਂ ਖੇਡਿਆ ਜਾ ਸਕਦਾ ਹੈ, ਅਤੇ ਗੇਮ ਤੋਂ ਬਾਅਦ ਇੱਕ ਇਸ਼ਤਿਹਾਰ ਆਉਂਦਾ ਹੈ। OUTREPD Pro, ਹਫ਼ਤਾਵਾਰੀ ਜਾਂ ਸਾਲਾਨਾ ਸਬਸਕ੍ਰਿਪਸ਼ਨ, ਇਸ਼ਤਿਹਾਰ ਹਟਾ ਦਿੰਦਾ ਹੈ।' },
  'ta-IN': { adv: 'Adventure: ஏழு உலகங்களில் 140 புஷ்-அப் சண்டைகள், பரிணமிக்கும் அரக்கர்கள் மற்றும் திறக்க வேண்டிய ஆயுதங்களுடன். உங்கள் தரவரிசை பணயத்தில் இல்லை.', pro: 'எல்லா முறைகளையும் சந்தா இல்லாமல் விளையாடலாம், ஒவ்வொரு விளையாட்டுக்குப் பிறகும் ஒரு விளம்பரம் வரும். வாராந்திர அல்லது ஆண்டு சந்தாவான OUTREPD Pro விளம்பரங்களை நீக்குகிறது.' },
  'te-IN': { adv: 'Adventure: ఏడు ప్రపంచాల్లో 140 పుష్-అప్ పోరాటాలు, పరిణామం చెందే రాక్షసులు, అన్‌లాక్ చేయాల్సిన ఆయుధాలతో. మీ ర్యాంక్ పణంగా ఉండదు.', pro: 'ప్రతి మోడ్‌ను సబ్‌స్క్రిప్షన్ లేకుండా ఆడవచ్చు, ఆట తర్వాత ఒక ప్రకటన వస్తుంది. వారపు లేదా వార్షిక సబ్‌స్క్రిప్షన్ అయిన OUTREPD Pro ప్రకటనలను తొలగిస్తుంది.' },
};

// The subscription sentence out, the new one in, the renewal terms kept.
function swapLead(line, pro, old) {
  let rest;
  if (old) {
    if (!line.startsWith(old)) throw new Error(`no "${old}" to replace`);
    rest = line.slice(old.length).trimStart();
  } else {
    const m = line.match(/^.*?[.。।۔]\s*/u);
    if (!m) throw new Error(`no first sentence in "${line.slice(0, 40)}"`);
    rest = line.slice(m[0].length);
  }
  const gap = /[。]$/.test(pro) ? '' : ' ';
  return rest ? `${pro}${gap}${rest}` : pro;
}

// Rewrites each locale's description, on a copy: storefronts share one
// object (the four English ones do). A description not shaped as
// expected stops the build rather than going out half changed.
function apply(locales) {
  for (const [locale, x] of Object.entries(locales)) {
    const parts = x.description.split('\n\n');
    const last = parts[parts.length - 1].split('\n');
    if (fullFor[locale]) {
      const f = fullFor[locale];
      if (parts.length !== 12 || last.length !== 4) throw new Error(`${locale}: not the full shape`);
      last.splice(0, 2, f.proHead, swapLead(last[1], f.pro));
      parts[parts.length - 1] = last.join('\n');
      // After the ranks: Adventure is the climb's worlds, Iron to Master.
      parts.splice(5, 0, `${f.advHead}\n${f.adv}`);
    } else if (short[locale]) {
      const s = short[locale];
      if (parts.length !== 5 || last.length !== 3) throw new Error(`${locale}: not the short shape`);
      last[0] = swapLead(last[0], s.pro, s.old);
      parts[parts.length - 1] = last.join('\n');
      parts.splice(2, 0, s.adv);
    } else {
      throw new Error(`${locale}: no ads and Adventure text`);
    }
    locales[locale] = { ...x, description: parts.join('\n\n') };
  }
  return locales;
}

module.exports = { apply };
