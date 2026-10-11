// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class LJa extends L {
  LJa([String locale = 'ja']) : super(locale);

  @override
  String get tabFriends => 'フレンド';

  @override
  String get tabRanks => 'ランク';

  @override
  String get tabMatch => 'マッチ';

  @override
  String get tabProfile => 'プロフィール';

  @override
  String get challengeFriend => 'フレンドに挑む';

  @override
  String get matchHistory => 'マッチ履歴';

  @override
  String get allMatches => 'すべてのマッチ';

  @override
  String get wins => '勝ち';

  @override
  String get losses => '負け';

  @override
  String get winRate => '勝率';

  @override
  String get streak => '連続記録';

  @override
  String get settings => '設定';

  @override
  String get accountSection => 'アカウント';

  @override
  String get duelSection => 'デュエル';

  @override
  String get hapticsEachRep => 'レップごとに振動';

  @override
  String get showSkeleton => 'スケルトンを表示';

  @override
  String get showSkeletonHint => 'カメラが認識しているか分かります';

  @override
  String get manageNotifications => '通知を管理';

  @override
  String switchesOn(String on, String all) {
    return '$all 件中 $on 件オン';
  }

  @override
  String get whoCanChallenge => '誰が挑戦できるか';

  @override
  String get blockedAccounts => 'ブロックしたアカウント';

  @override
  String get reportProblem => '問題を報告';

  @override
  String get onDeviceNote => '姿勢検出はこの端末で動きます。動画も姿勢データもアップロードされません。';

  @override
  String get visibilitySection => '表示';

  @override
  String get showMyCountry => '国を表示';

  @override
  String get showMyCountryHint => 'オフにすると国別ボードから外れます';

  @override
  String get safetySection => '安全';

  @override
  String get socialSection => 'ソーシャル';

  @override
  String get noticeRaced => '誰かが自分のセットに挑んだ';

  @override
  String get noticeRacedHint => 'デュエルがあったと分かる唯一の方法';

  @override
  String get noticeFriendOk => '送ったリクエストが承認された';

  @override
  String get noticesStoredNote => 'オフにすると保存自体されません。隠すのではありません。';

  @override
  String get notSaved => '保存できませんでした';

  @override
  String get blockedIntro => 'ブロックしたアカウントは挑戦も検索もリクエストもできません。相手に通知はされません。';

  @override
  String blockedWhen(String when) {
    return '$when にブロック';
  }

  @override
  String get unblock => 'ブロック解除';

  @override
  String get noBlockedTitle => 'ブロックはありません';

  @override
  String get noBlockedBody => 'プロフィールか報告画面からブロックできます。';

  @override
  String get whatHappened => '何がありましたか';

  @override
  String get reasonCheating => '不正または偽のレップ';

  @override
  String get reasonHarassment => '嫌がらせや暴言';

  @override
  String get reasonContent => '不適切なコンテンツ';

  @override
  String get reasonImpersonation => 'なりすまし';

  @override
  String get reasonOther => 'その他';

  @override
  String get addDetails => '詳細を追加（任意）';

  @override
  String get alsoBlock => 'このアカウントもブロックする';

  @override
  String get sendReport => '報告を送信';

  @override
  String get reportSent => '報告を送信しました';

  @override
  String get reportingThisAccount => 'このアカウントを報告します';

  @override
  String get exportIntro =>
      'サーバーが保持しているあなたの情報をすべてまとめたファイルをメールで送ります。通常 1 分ほどです。';

  @override
  String get whatsIncluded => '含まれるもの';

  @override
  String get incProfile => 'プロフィールとランク';

  @override
  String get incSets => 'すべてのセットとレップ数';

  @override
  String get incDuels => 'デュエル履歴と LP の変動';

  @override
  String get incFriends => 'フレンドとブロックしたアカウント';

  @override
  String get incNotices => '受け取った通知';

  @override
  String get noLandmarksNote =>
      '姿勢のランドマークは含まれていませんし、もともと存在しません。カメラが端末上で読み取り、どこにも送られません。';

  @override
  String get sendItTo => '送信先';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get createAccountTitle => 'アカウントを作成';

  @override
  String get createAccountBody =>
      'メールアドレスとパスワードを追加して、このアカウントが1台の端末だけに頼らないようにしましょう。';

  @override
  String get createAccountAction => 'アカウントを作成';

  @override
  String get emailTakenSwitchToSignIn => 'このメールアドレスはすでに登録されています — サインインしてください。';

  @override
  String get emailSignUpInvalid => 'メールアドレスとパスワードを確認してください（6文字以上）。';

  @override
  String get tooManyCodes => 'コードの送信回数が多すぎます。数分待ってからもう一度お試しください。';

  @override
  String get sendCodeAction => 'コードを送信';

  @override
  String get noAccountForEmail => 'そのメールアドレスのアカウントが見つかりませんでした。';

  @override
  String get authEntryTagline => '腕立てして、競って、駆け上がれ。';

  @override
  String get signUpWithEmail => 'メールで登録';

  @override
  String get alreadyHaveAccountQuestion => 'すでにアカウントをお持ちですか?';

  @override
  String get logInAction => 'ログイン';

  @override
  String get createYourAccountTitle => 'アカウントを作成';

  @override
  String get createAccountSubtitle => '1分もかかりません。';

  @override
  String get usernameLabel => 'ユーザー名';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get logInSubtitle => 'ランクを維持するにはログインしてください。';

  @override
  String get checkYourEmailTitle => 'メールを確認してください';

  @override
  String codeSentTo(String email) {
    return '$email に6桁のコードを送信しました。';
  }

  @override
  String get didntGetIt => '届きませんか?';

  @override
  String resendInSeconds(String time) {
    return '$time 後に再送信';
  }

  @override
  String get wrongEmailGoBack => 'メールアドレスが違う? 戻る';

  @override
  String get usernameTaken => 'そのユーザー名は使われています。';

  @override
  String get wrongCode => 'コードが間違っているか、期限切れです。';

  @override
  String get resendCode => 'コードを再送信';

  @override
  String get codeResent => '新しいコードを送信しました。';

  @override
  String signedInAs(String email) {
    return '$email でサインイン済み';
  }

  @override
  String get addressNotKept => 'アドレスは一度だけ使われ、保存されません。このアカウントにメールアドレスはありません。';

  @override
  String get requestMyData => 'データをメールで送る';

  @override
  String exportSent(String address) {
    return '$address に送信しました';
  }

  @override
  String get deleteIntro => 'すべてが完全に削除されます。取り消しも復元もできません。';

  @override
  String get rankLabel => 'ランク';

  @override
  String get wantCopyFirst => '先にコピーが必要ですか？';

  @override
  String get wantCopyBody => '削除する前にデータを受け取ってください。この後は戻りません。';

  @override
  String typeToConfirm(String word) {
    return '確認のため $word と入力';
  }

  @override
  String get deleteWord => '削除';

  @override
  String get deletePermanently => '完全に削除';

  @override
  String get keepMyAccount => 'アカウントを残す';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get skip => 'スキップ';

  @override
  String get yourPicture => 'あなたの写真';

  @override
  String get yourPictureHint => 'フレームはランクによって決まり、昇格すると変わります。';

  @override
  String get couldNotUsePicture => 'その画像は使用できませんでした';

  @override
  String get couldNotSyncAvatar => '写真は保存されましたが、まだ同期されていません';

  @override
  String get couldNotShareCard => 'このカードを共有できませんでした';

  @override
  String get couldNotOpenLink => 'そのリンクを開けませんでした';

  @override
  String get couldNotCheckUsername => 'その名前を確認できませんでした。もう一度お試しください';

  @override
  String get changeUsername => 'ユーザー名を変更';

  @override
  String get usernameInvalidLength => '4〜20文字の半角英数字と _ のみで入力してください';

  @override
  String get usernameChanged => 'ユーザー名を変更しました';

  @override
  String get usernameAlreadyChangedBody => 'ユーザー名の変更は一度きりで、すでに使用済みです。';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get camera => 'カメラ';

  @override
  String get awards => 'アワード';

  @override
  String get yourTitles => '獲得した称号';

  @override
  String get stillToEarn => '未獲得の称号';

  @override
  String get noTitlesYet => 'まだありません。最初の1つはマッチ1回で取れます。';

  @override
  String get wearHint => 'タップすると身につけられます。人があなたを見る場所すべてで、名前の横に表示されます。';

  @override
  String get worn => '着用中';

  @override
  String get titleUnlocked => '称号を獲得';

  @override
  String get wearIt => '身につける';

  @override
  String get wearItLater => 'あとで';

  @override
  String get dayStreak => '日連続';

  @override
  String get bestEver => '自己最高';

  @override
  String get restDaysLeft => '残りの休養日';

  @override
  String get restIsTraining => '休養もトレーニングのうち。週に2日休んでも連続記録は途切れません。';

  @override
  String get global => 'グローバル';

  @override
  String get topPlayers => 'トッププレイヤー';

  @override
  String get yourTier => '自分のティア';

  @override
  String get challenge => '挑む';

  @override
  String get notifications => '通知';

  @override
  String get start => '開始';

  @override
  String get finish => '終了';

  @override
  String get reps => 'レップ';

  @override
  String get howManyReally => '実際は何回でしたか？';

  @override
  String get howManyReallyHint => 'アプリではなくあなた自身の数です。あとでカウンターの精度を測る基準になります。';

  @override
  String get appearance => '外観';

  @override
  String get theme => 'テーマ';

  @override
  String get language => '言語';

  @override
  String get privacy => 'プライバシー';

  @override
  String get data => 'データ';

  @override
  String get about => 'このアプリについて';

  @override
  String get themeSystem => '端末に合わせる';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get accept => '承認';

  @override
  String get visEveryone => '全員';

  @override
  String get visFriends => 'フレンドのみ';

  @override
  String get visNobody => '非公開';

  @override
  String get friendRequestsLabel => 'フレンド申請';

  @override
  String get showOnLeaderboards => 'ランキングに表示する';

  @override
  String get exportData => 'データを書き出す';

  @override
  String get version => 'バージョン';

  @override
  String get rateApp => 'OUTREPD を評価する';

  @override
  String get contactSupport => 'サポートに連絡';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get openSourceLicences => 'オープンソースライセンス';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get needsServer => '接続できませんでした。インターネット接続を確認して、もう一度お試しください。';

  @override
  String get roomFriendly => 'ルームマッチは親善戦です。ランクには影響しません。';

  @override
  String get shareThisCode => 'このコードを共有';

  @override
  String get codeCopied => 'コードをコピーしました';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'アイアン';

  @override
  String get tierBronze => 'ブロンズ';

  @override
  String get tierSilver => 'シルバー';

  @override
  String get tierGold => 'ゴールド';

  @override
  String get tierPlatinum => 'プラチナ';

  @override
  String get tierDiamond => 'ダイヤモンド';

  @override
  String get tierMaster => 'マスター';

  @override
  String winLoss(String w, String l) {
    return '$w勝 $l敗';
  }

  @override
  String get continueLabel => '次へ';

  @override
  String get ttl_first_blood => 'ファーストブラッド';

  @override
  String get tdesc_first_blood => '初めてのマッチを終える';

  @override
  String get ttl_found_footing => '足場を固めた';

  @override
  String get tdesc_found_footing => '5マッチを終える';

  @override
  String get ttl_regular => '常連';

  @override
  String get tdesc_regular => '20マッチ';

  @override
  String get ttl_fifty => '50の大台';

  @override
  String get tdesc_fifty => '50マッチ';

  @override
  String get ttl_century => 'センチュリー';

  @override
  String get tdesc_century => '100マッチ';

  @override
  String get ttl_veteran => 'ベテラン';

  @override
  String get tdesc_veteran => '250マッチ';

  @override
  String get ttl_thousand_matches => '古参';

  @override
  String get tdesc_thousand_matches => '1000マッチ';

  @override
  String get ttl_first_win => 'ウィナー';

  @override
  String get tdesc_first_win => 'マッチに勝つ';

  @override
  String get ttl_on_a_roll => '波に乗る';

  @override
  String get tdesc_on_a_roll => '3連勝する';

  @override
  String get ttl_five_straight => '5連勝';

  @override
  String get tdesc_five_straight => '5連勝する';

  @override
  String get ttl_unstoppable => '止められない';

  @override
  String get tdesc_unstoppable => '10連勝する';

  @override
  String get ttl_untouchable => 'アンタッチャブル';

  @override
  String get tdesc_untouchable => '20連勝する';

  @override
  String get ttl_giant_slayer => 'ジャイアントキラー';

  @override
  String get tdesc_giant_slayer => '2ランク上の相手に勝つ';

  @override
  String get ttl_comeback => 'カムバック';

  @override
  String get tdesc_comeback => '3連敗の直後に勝つ';

  @override
  String get ttl_nemesis => '宿敵';

  @override
  String get tdesc_nemesis => '同じ相手に5回勝つ';

  @override
  String get ttl_hundred_reps => '滑り出し';

  @override
  String get tdesc_hundred_reps => 'カウント100レップ';

  @override
  String get ttl_five_hundred => 'ウォームアップ完了';

  @override
  String get tdesc_five_hundred => 'カウント500レップ';

  @override
  String get ttl_the_machine => 'マシーン';

  @override
  String get tdesc_the_machine => 'カウント1000レップ';

  @override
  String get ttl_five_thousand => '容赦なし';

  @override
  String get tdesc_five_thousand => 'カウント5000レップ';

  @override
  String get ttl_ten_thousand => '一万レップ';

  @override
  String get tdesc_ten_thousand => 'カウント10000レップ';

  @override
  String get ttl_fifty_thousand => '数え切れない';

  @override
  String get tdesc_fifty_thousand => 'カウント50000レップ';

  @override
  String get ttl_first_tonne => '1トン';

  @override
  String get tdesc_first_tonne => '累計1000キロを挙げる';

  @override
  String get ttl_ten_tonnes => '10トン';

  @override
  String get tdesc_ten_tonnes => '累計10000キロを挙げる';

  @override
  String get ttl_six_figures => '6桁';

  @override
  String get tdesc_six_figures => '累計10万キロを挙げる';

  @override
  String get ttl_half_million => '50万キロ';

  @override
  String get tdesc_half_million => '累計50万キロを挙げる';

  @override
  String get ttl_million_kg => '100万キロクラブ';

  @override
  String get tdesc_million_kg => '累計100万キロを挙げる';

  @override
  String get ttl_two_days => 'また来た';

  @override
  String get tdesc_two_days => '2日続けてトレーニングする';

  @override
  String get ttl_no_days_off => '休みなし';

  @override
  String get tdesc_no_days_off => '7日続けてトレーニングする';

  @override
  String get ttl_fortnight => '2週間';

  @override
  String get tdesc_fortnight => '14日連続記録';

  @override
  String get ttl_unbroken => '途切れず';

  @override
  String get tdesc_unbroken => '30日連続記録';

  @override
  String get ttl_sixty_days => '習慣';

  @override
  String get tdesc_sixty_days => '60日連続記録';

  @override
  String get ttl_hundred_days => '100日';

  @override
  String get tdesc_hundred_days => '100日連続記録';

  @override
  String get ttl_year_round => '通年';

  @override
  String get tdesc_year_round => '365日連続記録';

  @override
  String get ttl_perfect_week => 'パーフェクトウィーク';

  @override
  String get tdesc_perfect_week => '1週間毎日トレーニングする';

  @override
  String get ttl_perfect_month => 'パーフェクトマンス';

  @override
  String get tdesc_perfect_month => 'パーフェクトウィーク4回';

  @override
  String get ttl_bronze_tier => 'アイアンを脱する';

  @override
  String get tdesc_bronze_tier => 'ブロンズに到達';

  @override
  String get ttl_silver_tier => 'シルバーサイド';

  @override
  String get tdesc_silver_tier => 'シルバーに到達';

  @override
  String get ttl_golden_era => '黄金時代';

  @override
  String get tdesc_golden_era => 'ゴールドに到達';

  @override
  String get ttl_platinum_tier => 'プラチナ';

  @override
  String get tdesc_platinum_tier => 'プラチナに到達';

  @override
  String get ttl_diamond_tier => 'ダイヤモンドハンド';

  @override
  String get tdesc_diamond_tier => 'ダイヤモンドに到達';

  @override
  String get ttl_master_tier => 'マスター';

  @override
  String get tdesc_master_tier => 'マスターに到達';

  @override
  String get ttl_clean_hands => 'クリーンハンド';

  @override
  String get tdesc_clean_hands => '全レップがカウントされた1セット';

  @override
  String get ttl_spotless => '非の打ちどころなし';

  @override
  String get tdesc_spotless => 'クリーンなセット10回';

  @override
  String get ttl_textbook => 'お手本どおり';

  @override
  String get tdesc_textbook => 'クリーンなセット50回';

  @override
  String get ttl_all_rounder => 'オールラウンダー';

  @override
  String get tdesc_all_rounder => '5種目をカウントする';

  @override
  String get ttl_explorer => 'エクスプローラー';

  @override
  String get tdesc_explorer => '15種目をカウントする';

  @override
  String get ttl_encyclopedia => '百科事典';

  @override
  String get tdesc_encyclopedia => '40種目をカウントする';

  @override
  String get ttl_early_bird => '早番';

  @override
  String get tdesc_early_bird => '朝7時前に10セッション';

  @override
  String get ttl_sunrise_club => 'サンライズクラブ';

  @override
  String get tdesc_sunrise_club => '朝7時前に50セッション';

  @override
  String get ttl_night_owl => '夜勤';

  @override
  String get tdesc_night_owl => '夜10時以降に10セッション';

  @override
  String get ttl_graveyard => '深夜勤';

  @override
  String get tdesc_graveyard => '夜10時以降に50セッション';

  @override
  String get ttl_not_alone => 'ひとりじゃない';

  @override
  String get tdesc_not_alone => '最初のフレンドを追加する';

  @override
  String get ttl_well_connected => '顔が広い';

  @override
  String get tdesc_well_connected => 'フレンド10人';

  @override
  String get ttl_the_gym_knows => 'ジムが君を知っている';

  @override
  String get tdesc_the_gym_knows => 'フレンド50人';

  @override
  String get forfeitQ => 'マッチを棄権しますか？';

  @override
  String get forfeitBody => 'いま抜けると LP を失います。';

  @override
  String get stay => '残る';

  @override
  String get forfeit => '棄権';

  @override
  String get getReady => '準備';

  @override
  String get you => 'あなた';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get mgChest => '胸';

  @override
  String get nWonTitle => '勝ちました！';

  @override
  String nWonBody(String name, String muscle) {
    return '$muscle の日に $name に勝ちました';
  }

  @override
  String get nFriendTitle => '新しいフレンド申請';

  @override
  String get nRacedTitle => 'あなたのセットが挑まれました';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name があなたのセットに挑み、届きませんでした $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name があなたのセットに挑み、勝ちました $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'フレンド申請が承認されました';

  @override
  String nFriendOkBody(String name) {
    return '$name がリクエストを承認しました';
  }

  @override
  String nFriendBody(String name) {
    return '$name がつながりを希望しています';
  }

  @override
  String get nChallengedTitle => '再戦';

  @override
  String nChallengedBody(String name) {
    return '$nameさんが再戦を希望しています';
  }

  @override
  String get challengeSentTitle => '挑戦を送信しました';

  @override
  String challengeSentBody(String name) {
    return '$nameに知らせます。相手が挑戦したら戻ってきてください。';
  }

  @override
  String get challengeNotSentTitle => '送信できませんでした';

  @override
  String get challengeNotSentBody => '接続を確認して、マッチタブからもう一度お試しください。';

  @override
  String get challengeGoneTitle => '挑戦はもうありません';

  @override
  String get challengeGoneBody => 'すでに対戦済みか、取り下げられました。';

  @override
  String repsRecordedLine(String reps) {
    return '$reps回を記録しました';
  }

  @override
  String get nAchTitle => '実績を解放';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'ランクアップ！';

  @override
  String nRankBody(String rank) {
    return '$rank に到達しました';
  }

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String daysAgo(String n) {
    return '$n 日前';
  }

  @override
  String weeksAgo(String n) {
    return '$n 週間前';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get lpUnit => 'LP';

  @override
  String get trueCountHint => '例: 12';

  @override
  String get couldNotSaveSession => 'セッションを保存できませんでした';

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String get noFriendsTitle => 'フレンドはまだいません';

  @override
  String get noFriendsBody => '知っている相手との勝負はひと味違います。';

  @override
  String get decline => '辞退';

  @override
  String requestSent(String name) {
    return '$name にリクエストを送りました';
  }

  @override
  String nowFriends(String name) {
    return '$name とフレンドになりました';
  }

  @override
  String get noOneFound => 'その名前の人はいません';

  @override
  String get noMatchesTitle => 'マッチはまだありません';

  @override
  String get noMatchesBody => '最初の一戦は、勝っても負けてもここに残ります。';

  @override
  String get noNotificationsTitle => '新しい知らせはありません';

  @override
  String get noNotificationsBody => 'マッチの招待、結果、フレンド申請がここに届きます。';

  @override
  String get countedThat => 'このラウンドの回数';

  @override
  String get thatIsRight => 'これで合っています';

  @override
  String get useMyCount => '自分の数を使う';

  @override
  String get confirmHint => 'カメラが間違っていたら直してください。';

  @override
  String get unsureMovement => '正しい種目か確信が持てません。数を確認してください。';

  @override
  String get noRanksYet => 'No ranks yet';

  @override
  String get noRanksYetBody => 'Play a duel and the board fills in.';

  @override
  String get ranksTitle => 'Ranks';

  @override
  String get totalReps => 'Total reps';

  @override
  String get recent => 'Recent';

  @override
  String wonVs(String name) {
    return 'Won vs $name';
  }

  @override
  String lostVs(String name) {
    return 'Lost vs $name';
  }

  @override
  String hoursAgo(String n) {
    return '${n}h ago';
  }

  @override
  String toNextTier(String n, String tier) {
    return '$n to $tier';
  }

  @override
  String get noMatchesYet => 'No duels yet';

  @override
  String get noMatchesYetBody => 'Your first one shows up here, win or lose.';

  @override
  String get searchByUsername => 'ユーザー名で検索';

  @override
  String get incomingRequests => '受信した申請';

  @override
  String get noRequestsWaiting => '今のところ保留中のリクエストはありません';

  @override
  String get addFriendAction => '友達を追加';

  @override
  String get addFriendHint => '相手のユーザー名か、プロフィールにある#コードを入力してください。';

  @override
  String get usernameOrCode => 'ユーザー名または#コード';

  @override
  String get sendRequest => 'リクエストを送信';

  @override
  String onlineNowCount(String count) {
    return 'オンライン · $count';
  }

  @override
  String offlineCount(String count) {
    return 'オフライン · $count';
  }

  @override
  String get invite => '招待';

  @override
  String get headToHeadTitle => '対戦成績';

  @override
  String get vsYouCaption => 'あなたとの対戦';

  @override
  String get h2hYou => 'あなた';

  @override
  String get h2hThem => '相手';

  @override
  String headToHead(String wins, String losses) {
    return 'あなたに$wins勝$losses敗';
  }

  @override
  String get neverPlayedYou => '対戦したことがありません';

  @override
  String noHistoryWithThem(String username) {
    return '$usernameとはまだ対戦していません。';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return '前回: $yourReps–$theirReps、$when。';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return '相手に対するあなたの自己ベストは$repsです。';
  }

  @override
  String get viewFullProfile => 'プロフィールをすべて見る';

  @override
  String get moreOptions => 'その他のオプション';

  @override
  String get block => 'ブロック';

  @override
  String get blockRowBody => '挑戦もプロフィール閲覧もできなくなります';

  @override
  String get report => '報告';

  @override
  String get reportRowBody => '24時間以内に確認されます';

  @override
  String muteChallenges(String username) {
    return '$usernameからの挑戦をミュート';
  }

  @override
  String blockedLifter(String username) {
    return '$usernameをブロックしました';
  }

  @override
  String mutedLifter(String username) {
    return '$usernameをミュートしました';
  }

  @override
  String get addFriendButton => '友達に追加';

  @override
  String get alreadyFriends => '友達';

  @override
  String get couldNotLoadProfile => 'プロフィールを読み込めませんでした';

  @override
  String get noFriendsMatch => 'その名前の人はいません';

  @override
  String get yourClimb => 'あなたの登り';

  @override
  String floorKept(String tier, String rank) {
    return '$tier はあなたのものです。$rank より下には落ちません。';
  }

  @override
  String dayStreakCount(String count) {
    return '$count日連続';
  }

  @override
  String get findMatch => 'マッチを探す';

  @override
  String rankedTerms(String seconds) {
    return '$seconds秒 · ランク戦';
  }

  @override
  String get practiceTerms => '練習 — ランクなし、対戦相手なし';

  @override
  String get practiceComplete => '練習終了';

  @override
  String get noRankYet => 'まだランクなし';

  @override
  String placementsForFirstTier(String count) {
    return '最初のランクを得るには配置マッチを$count回こなしてください。';
  }

  @override
  String get startPlacements => '配置マッチを始める';

  @override
  String get unranked => 'ランクなし';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$total回中$done回 · 各$seconds秒';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$total回中$done回 · ランクまであと$left回';
  }

  @override
  String placementsForTier(String count) {
    return '自分のランクを知るには配置マッチを$count回こなしてください。';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '配置$total回中$done回完了';
  }

  @override
  String get practiceFirst => 'まず練習';

  @override
  String get nextPlacement => '次の配置マッチ';

  @override
  String get noConnection => '接続なし';

  @override
  String get practiceOffline => 'オフラインで練習';

  @override
  String get retry => '再試行';

  @override
  String get youWonPlain => '勝ち';

  @override
  String get cameraNeededTitle => 'カメラの許可が必要です';

  @override
  String get cameraNeededBody =>
      'outrepd は体の動きを見て回数を数えます。解析は端末上で行われ、何も送信されません。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get allowCamera => 'カメラを許可';

  @override
  String get notNow => '今はしない';

  @override
  String get noCameraTitle => 'カメラがありません';

  @override
  String get noCameraBody => '回数はカメラで数えるため、この端末では勝負を採点できません。他の機能は使えます。';

  @override
  String get noConnectionBody => '対戦には接続が必要です。練習はオフラインでもでき、回数はあとで同期されます。';

  @override
  String get getBackInFrame => '画面に戻って';

  @override
  String get clockStillRunning => '時間は進んでいます。カウントは止まっています。';

  @override
  String get giveUp => '棄権';

  @override
  String get lpMovesWithGap => 'LPはレップ差で変動します。差が大きいほど獲得LPも増えます';

  @override
  String get searchingForOpponent => '対戦相手を探しています';

  @override
  String get getIntoPosition => '位置について';

  @override
  String get framingHint => '手首と足首が画面に入るように';

  @override
  String get goUp => '上げて';

  @override
  String get goDown => '下げて';

  @override
  String get bestSet => 'ベストセット';

  @override
  String get record => '成績';

  @override
  String get last7Days => '直近7日';

  @override
  String repsCount(String count) {
    return '$count回';
  }

  @override
  String get viewAll => 'すべて見る';

  @override
  String get shareProfile => 'プロフィールを共有';

  @override
  String get share => '共有';

  @override
  String get duelMeOnOutrepd => 'outrepdで勝負しよう';

  @override
  String get shareStory => 'ストーリー';

  @override
  String get sharePost => '投稿';

  @override
  String get copyLink => 'コピー';

  @override
  String get linkCopied => 'リンクをコピーしました';

  @override
  String get currentRankLabel => '現在のランク';

  @override
  String get winInitial => '勝';

  @override
  String get lossInitial => '敗';

  @override
  String get dayInitial => '日';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline => '腕立ての勝負。スマホが数える。相手も数えている。';

  @override
  String get obGetStarted => 'はじめる';

  @override
  String get obHaveAccount => 'アカウントを持っている';

  @override
  String get obTwoThings => '手早く2つだけ。';

  @override
  String get obAgeQuestion => '年齢は?';

  @override
  String get obUnder16 => '16歳未満';

  @override
  String get obOver16 => '16歳以上';

  @override
  String get obHealthConsent =>
      'outrepd は回数を数えるだけで、医療やトレーニングの助言はしないと理解しています。痛みが出たらやめます。';

  @override
  String get obTermsIntro => '続けると、以下に同意したものとみなされます:';

  @override
  String get obTerms => '利用規約';

  @override
  String get obAnd => 'と';

  @override
  String get obPrivacy => 'プライバシーポリシー';

  @override
  String get obUnder16Blocked => 'outrepd は16歳以上向けです。その歳になったら戻ってきて。腕立てはなくならない。';

  @override
  String get obCameraTitle => 'outrepd にはカメラが必要';

  @override
  String get obCameraBody => '体の動きを見て数えます。ほかに方法はありません。';

  @override
  String get obCameraPrivateTitle => 'スマホの外には出ない';

  @override
  String get obCameraPrivateBody => '体の検出はこの端末の中で行われます。動画が保存・送信されることはありません。';

  @override
  String get obWhyNeeded => 'なぜ必要?';

  @override
  String get obPlacementTitle => 'スマホを床に置く';

  @override
  String get obPlacementBody => '1メートルほど前の壁に立てかける。';

  @override
  String get obOneMetre => '約1m';

  @override
  String get obFullBody => '全身がフレームに入る';

  @override
  String get obCheckHandsFeet => '手と足の両方が見える';

  @override
  String get obCheckFacing => '横向きではなく、スマホの方を向く';

  @override
  String get obCheckLight => '部屋の明かりをつける';

  @override
  String get obImSetUp => '準備できた';

  @override
  String get obFramingTitle => '腕立ての姿勢になる';

  @override
  String get obFramingShoulders => '肩と腰';

  @override
  String get obFramingWrists => '手首';

  @override
  String get obFramingAnkles => '足首';

  @override
  String get obLooksGood => 'いい感じ';

  @override
  String get obCalibrating => '調整中';

  @override
  String get obOneMoreRep => '可動域を測るのであと1回';

  @override
  String get obCalibrationHint => 'いつもの深さで3回やってみて';

  @override
  String get obCalibrated => '調整完了。';

  @override
  String get obCalibratedBody =>
      'outrepd があなたの可動域を覚えました。深さは固定の数値ではなく、あなたを基準に測ります。';

  @override
  String get obRepsCounted => '数えた回数';

  @override
  String get obAverageDepth => '平均の深さ';

  @override
  String get obForm => 'フォーム';

  @override
  String get obFormClean => 'きれい';

  @override
  String get obAvailable => '使える';

  @override
  String get obTaken => '使用済み';

  @override
  String get obGotIt => 'わかった';

  @override
  String get obFormMixed => 'ばらつきあり';

  @override
  String get justNow => 'たった今';

  @override
  String get counterAccuracy => 'カウントの精度';

  @override
  String get counterAccuracyCaption => 'カメラがどれだけ正確か';

  @override
  String measuredOverSets(String count) {
    return '$count セットで測定';
  }

  @override
  String get accExact => 'ぴったり';

  @override
  String get accWithinOne => '誤差1回以内';

  @override
  String get accAverageMiss => '平均誤差';

  @override
  String get accTendsTo => '傾向';

  @override
  String get accCountsHigh => '多めに数える';

  @override
  String get accCountsLow => '少なめに数える';

  @override
  String get accCountsEven => 'どちらでもない';

  @override
  String get accWorstMiss => '最大の誤差';

  @override
  String get accNothingYet => 'まだ測定なし';

  @override
  String get accNothingYetBody =>
      '対戦後に回数を確認するたび、そのセットがあなたの申告と照らし合わされます。結果はここに出ます。';

  @override
  String accNeedMore(String count) {
    return 'まだ序盤。この数字が意味を持つまであと $count セットほど。';
  }

  @override
  String get accRecentSets => '最近のセット';

  @override
  String get accCameraSaid => 'カメラ';

  @override
  String get accYouSaid => 'あなた';

  @override
  String get accHowItWorks => 'これはこの端末の、あなた自身のデータです。どこにも送信されません。';

  @override
  String levelNumber(String n) {
    return 'レベル $n';
  }

  @override
  String get youLostPlain => '負け';

  @override
  String get rematch => '再戦';

  @override
  String get shareAction => '共有';

  @override
  String get doneAction => '完了';

  @override
  String get continueAction => '続ける';

  @override
  String get promotedLabel => '昇格';

  @override
  String get highestReached => '自己最高';

  @override
  String repsOff(String n) {
    return '$n 回差。';
  }

  @override
  String get closestYet => 'これまでで最も僅差。';

  @override
  String repsAhead(String n) {
    return '$n回差で勝利。';
  }

  @override
  String get winnerLabel => '勝者';

  @override
  String get newPersonalBest => '自己ベスト更新';

  @override
  String get cantReachServer => 'サーバーに接続できませんでした。接続を確認して、もう一度お試しください。';

  @override
  String pushUpsInSeconds(String seconds) {
    return '$seconds秒間の腕立て伏せ';
  }

  @override
  String beatOpponent(String name, String score) {
    return '$nameに勝利 $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return '$nameに敗北 $score';
  }

  @override
  String get thinkYouCanBeatMe => '私に勝てると思う？';

  @override
  String get usernameNotAllowed => 'この名前は使えません。別の名前にしてください。';

  @override
  String get yourBest => '自己ベスト';

  @override
  String get theClock => 'タイマー';

  @override
  String get nobodyFreeRaceBest =>
      '今は近いランクの相手がいません。自己ベストと勝負しましょう。この勝負でランクは変わりません。';

  @override
  String get nobodyFreeFirstScore =>
      '今は近いランクの相手がいません。最初の記録を作りましょう。この勝負でランクは変わりません。';

  @override
  String bestStillIs(String count) {
    return '自己ベストは $count のまま';
  }

  @override
  String get setInPoolTitle => '記録は対戦待ちに入りました';

  @override
  String get setInPoolBody =>
      '近いランクの次のプレイヤーがこの記録と対戦します。結果は通知で確認でき、そのときにランクが動きます。';

  @override
  String get obWhyNeededBody =>
      '1回ごとに肩がどれだけ下がって上がったかで判定します。それを見られるのはカメラだけです。カメラがなければカウントできず、カウントがなければ対戦もできません。カメラが動くのはセット中だけです。';

  @override
  String get obWelcomeBack => 'おかえり';

  @override
  String obTitlesHeading(String count) {
    return '獲得できる称号は$count個';
  }

  @override
  String get obTitlesBody => '勝利、連勝、きれいなセット、早朝トレーニングなどでもらえます。名前の下に1つ表示できます。';

  @override
  String get obFriendsHeading => '友達と決着をつけよう';

  @override
  String get obFriendsBody => '友達はこのコードであなたを追加できます。いつでも挑戦でき、2人の対戦成績は記録されます。';

  @override
  String get obLetsGo => '始めよう';

  @override
  String get paywallTitle => 'アイアンからマスターへ';

  @override
  String get paywallPerkDuels => 'カメラが判定するデュエル';

  @override
  String get paywallPerkLadder => 'リアルタイムのランキング';

  @override
  String get paywallPerkFriends => 'フレンドとチャレンジ';

  @override
  String get paywallPerkHistory => 'すべての試合のすべてのレップ';

  @override
  String get paywallYearly => '年額';

  @override
  String get paywallWeekly => '週額';

  @override
  String paywallPerWeek(String price) {
    return '週あたり${price}';
  }

  @override
  String get paywallEveryWeek => '毎週';

  @override
  String paywallSave(String percent) {
    return '${percent}%お得';
  }

  @override
  String get paywallStart => '登りはじめる';

  @override
  String get paywallRenewsPlay => '解約するまで自動更新されます。Google Playからいつでも解約できます。';

  @override
  String get paywallRenewsApple => '解約するまで自動更新されます。Appleアカウントの設定からいつでも解約できます。';

  @override
  String get paywallRestore => '復元';

  @override
  String get paywallTerms => '利用規約';

  @override
  String get paywallPrivacy => 'プライバシー';

  @override
  String get paywallLoadFailed => 'プランを読み込めませんでした。接続を確認して、もう一度お試しください。';

  @override
  String get paywallBuyFailed => '購入が完了しませんでした。もう一度お試しください。';

  @override
  String get paywallPending => 'お支払いは保留中です。ストアで確認され次第、すべて利用できるようになります。';

  @override
  String get paywallNothingToRestore => '復元できるサブスクリプションが見つかりません。';

  @override
  String get paywallRestored => 'サブスクリプションを復元しました';

  @override
  String paywallSignedInAs(String email) {
    return '${email} でログイン中';
  }

  @override
  String get deleteKeepsSubscription => 'アカウントを削除してもサブスクリプションは解約されません。請求するのはストアで、outrepd ではありません。先に Google Play か Apple アカウントの設定で解約してください。';

  @override
  String get signOut => 'サインアウト';

  @override
  String get signOutQuestion => 'サインアウトしますか？';

  @override
  String get signOutBody => 'アカウントはランク、履歴、サブスクリプションごとそのまま残ります。メールアドレスでいつでも再びサインインできます。';

  @override
  String get shareVictory => '勝利';

  @override
  String get shareRematch => '再戦？';

  @override
  String friendCodeInvite(String code) {
    return 'outrepd で勝負しよう。フレンドコード ${code} で追加してね\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'サウンド';

  @override
  String get soundsHint => '3、2、1 のビープ、レップごとのティック、ラウンド終了の音。音楽と一緒に鳴ります。';

  @override
  String get phoneSection => 'この端末';

  @override
  String get allowNotifications => '通知を許可';

  @override
  String get allowNotificationsHint => '端末の設定で OUTREPD の通知がオフになっているため、以下の通知は届きません。';

  @override
  String get remindersSection => 'リマインダー';

  @override
  String get dailyReminder => '毎日のリマインダー';

  @override
  String get dailyReminderHint => 'まだトレーニングしていない日だけ。';

  @override
  String get reminderTime => '時刻';

  @override
  String get reminderTitle => '今日の腕立て伏せの時間です';

  @override
  String get reminderBody => '1セットでも連続記録に数えられます。';

  @override
  String reminderStreakBody(String count) {
    return '${count}日連続の記録を続けましょう。1セットで十分です。';
  }

  @override
  String get channelMatches => '対戦とフレンド';

  @override
  String get channelReminders => '毎日のリマインダー';

  @override
  String get liveTag => 'ライブ';

  @override
  String get reconnecting => '再接続中';

  @override
  String get rankedLive => 'ランク戦 · ライブ';

  @override
  String get lookingForLive => 'ライブの対戦相手を探しています';

  @override
  String ofTime(String time) {
    return '${time} 中';
  }

  @override
  String liveFallbackAt(String time) {
    return '${time} になると保存済みのセットと対戦します';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} が今カメラの前にいます。同じ時計、同時スタート。';
  }

  @override
  String get nobodyLiveTitle => '今ライブの人はいません';

  @override
  String get nobodyLiveBody => '代わりに保存済みのセットと対戦します';

  @override
  String didRepsIn(String reps) {
    return '60秒で ${reps} 回';
  }

  @override
  String get sameRankPoints => 'ライブ戦と同じランクポイント';

  @override
  String get raceIt => '対戦する';

  @override
  String get sendASet => 'セットを送る';

  @override
  String get onlineNow => 'オンライン';

  @override
  String get liveOrSetHint => 'ライブは相手がオンラインのときだけ。セットは相手が挑むまで待ちます。';

  @override
  String get friendlyNoRank => 'フレンドリー · ランクなし';

  @override
  String waitingForName(String name) {
    return '${name} を待っています';
  }

  @override
  String get weSentThemANotice => '通知を送りました';

  @override
  String get untilInviteRunsOut => '招待の期限まで';

  @override
  String get cancelInvite => '招待を取り消す';

  @override
  String inviteDeclined(String name) {
    return '${name} は今は無理なようです';
  }

  @override
  String get inviteRanOut => '招待の期限が切れました';

  @override
  String get inviteAgain => 'もう一度招待';

  @override
  String liveInviteFrom(String name) {
    return '${name} がライブ中';
  }

  @override
  String timeLeft(String time) {
    return '残り ${time}';
  }

  @override
  String get joinLive => '参加';

  @override
  String get nLiveTitle => 'ライブの招待';

  @override
  String nLiveBody(String name) {
    return '${name} がライブで対戦したがっています';
  }

  @override
  String get inviteGone => 'その招待は期限切れです';

  @override
  String opponentDropped(String name) {
    return '${name} の接続が切れました。続けて：ラウンドは時間で終わります。';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} が棄権しました。ラウンドを終えて勝利をつかもう。';
  }

  @override
  String get calledOffTitle => '対戦は中止になりました';

  @override
  String calledOffBody(String name) {
    return '${name} が時間内に構えられませんでした。記録は残りません。';
  }

  @override
  String waitingForFinal(String name) {
    return '${name} の最終カウントを待っています…';
  }

  @override
  String get wantsToBeFriends => 'フレンドになりたがっています';

  @override
  String get giveUpQuestion => 'このラウンドを棄権しますか？';

  @override
  String get giveUpBody => '今のカウントに関係なく、負けになります。';

  @override
  String waitingToJoin(String name) {
    return '${name}の参加を待っています';
  }

  @override
  String get removeFriend => 'フレンドを解除';

  @override
  String get removeFriendBody => '相手に通知はされず、あとでまたフレンドになれます';

  @override
  String removeFriendQuestion(String username) {
    return '${username}をフレンドから解除しますか？';
  }

  @override
  String get removeAction => '解除';

  @override
  String removedFriend(String username) {
    return '${username}をフレンドから解除しました';
  }

  @override
  String get noticeChallenged => 'リマッチを挑まれた';

  @override
  String get noticeLiveInvite => 'フレンドからライブ対戦に誘われた';

  @override
  String trialHeadline(String days) {
    return '最初の${days}日間は*無料*';
  }

  @override
  String get trialToday => '今日';

  @override
  String get trialTodayBody => 'ライブもランクも、すべての対戦が解放。';

  @override
  String trialDay(String day) {
    return '${day}日目';
  }

  @override
  String get trialReminderBody => 'トライアル終了の前日にお知らせします。';

  @override
  String get trialEndBody => 'プランが始まります。それまでに解約すれば料金はかかりません。';

  @override
  String trialTag(String days) {
    return '${days}日間無料';
  }

  @override
  String trialCta(String days) {
    return '${days}日間の無料トライアルを始める';
  }

  @override
  String trialThenYearly(String price) {
    return '今は支払いなし・その後${price}/年';
  }

  @override
  String trialThenWeekly(String price) {
    return '今は支払いなし・その後${price}/週';
  }

  @override
  String get trialEndsTitle => '無料トライアルは明日終了します';

  @override
  String get trialEndsBody => 'このまま続けるか、それまでにサブスクリプション設定で解約してください。';

  @override
  String get obIdeaTitle => '60秒。相手はひとり。';

  @override
  String get obIdeaRival => '本物の人と対戦。ライブでも、記録したセットでも';

  @override
  String get obIdeaCamera => 'カメラがすべての回数を、スマホの中で数えます';

  @override
  String get thisMonth => '今月';

  @override
  String shortDays(String n) {
    return '${n}日';
  }

  @override
  String shortHours(String n) {
    return '${n}時間';
  }

  @override
  String get awardChampion => 'チャンピオン';

  @override
  String get awardPodium => '表彰台';

  @override
  String get awardTop10 => 'トップ10';

  @override
  String get awardRegular => '常連';

  @override
  String monthToTop10(String lp) {
    return 'トップ10まであと${lp} LP';
  }

  @override
  String monthIfEndedNow(String award) {
    return '今月が今終われば${award}';
  }

  @override
  String get monthJoinHint => 'ランク戦を1回やると今月のボードに載ります';

  @override
  String monthRegularProgress(String progress) {
    return '常連バッジ · ランク戦 ${progress}';
  }

  @override
  String get monthRegularEarned => '今月の常連バッジを獲得';

  @override
  String get monthEmptyTitle => '新しい月';

  @override
  String get monthEmptyBody => '今月はまだ誰もLPを獲得していません。最初のランク戦に勝てば首位です。';

  @override
  String rankedDuelsCount(String n) {
    return 'ランク戦 ${n}回';
  }

  @override
  String get monthlyAwards => '月間アワード';

  @override
  String get seasonOver => 'シーズン終了';

  @override
  String get seasonOverBody => 'プロフィールに追加されました。新しい月はゼロからスタートです。';

  @override
  String get seasonPlayCta => '新しい月をプレイ';

  @override
  String get rematchLive => 'ライブで再戦';

  @override
  String rematchWaiting(String name) {
    return '${name}を待っています';
  }

  @override
  String rematchAsked(String name) {
    return '${name}が再戦を希望';
  }

  @override
  String get rematchGone => '今回は再戦なし';

  @override
  String get twoRankedADay => 'フレンドリー · 同じ相手とのランク戦は1日2回まで';

  @override
  String monthMove(String move) {
    return '今月 · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return '${rank}から';
  }
}
