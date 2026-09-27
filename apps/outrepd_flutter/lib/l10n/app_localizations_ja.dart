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
  String get passwordHint => 'パスワード';

  @override
  String get codeHint => '確認コード';

  @override
  String get createAccountTitle => 'アカウントを作成';

  @override
  String get createAccountBody =>
      'メールアドレスとパスワードを追加して、このアカウントが1台の端末だけに頼らないようにしましょう。';

  @override
  String get createAccountAction => 'アカウントを作成';

  @override
  String get signInTitle => 'サインイン';

  @override
  String get signInBody => 'アカウントのメールアドレスとパスワードでサインインしてください。';

  @override
  String get signInAction => 'サインイン';

  @override
  String get switchToSignIn => 'すでにアカウントをお持ちですか？サインイン';

  @override
  String get switchToSignUp => '初めてですか？アカウントを作成';

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
  String get orDivider => 'または';

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
  String get usernameHint => 'ユーザー名';

  @override
  String get usernameLabel => 'ユーザー名';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get passwordMinLength => '8文字以上';

  @override
  String get logInSubtitle => 'ランクを維持するにはログインしてください。';

  @override
  String get forgotPassword => 'パスワードをお忘れですか?';

  @override
  String resetPasswordSent(String email) {
    return '$email のアカウントが存在する場合、リセットリンクをお送りしています。';
  }

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
  String get socialLinkFailed => 'サインインを完了できませんでした。もう一度お試しください。';

  @override
  String get showLabel => '表示';

  @override
  String get hideLabel => '隠す';

  @override
  String get resetPasswordTitle => '新しいパスワードを設定';

  @override
  String get resetPasswordBody => 'アカウントの新しいパスワードを選んでください。';

  @override
  String get setPasswordAction => 'パスワードを設定';

  @override
  String get wrongEmailOrPassword => 'メールアドレスかパスワードが間違っています。';

  @override
  String get enterCodeTitle => 'コードを入力';

  @override
  String codeInstructions(String email) {
    return '$email に送信したコードを入力してください。';
  }

  @override
  String get verifyAction => '確認';

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
  String get height => '身長';

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
  String get simulatedOpponent => '他に対戦相手がいなかったため、これは練習ペースです';

  @override
  String get changeUsername => 'ユーザー名を変更';

  @override
  String get usernameInvalidLength => '4〜20文字の半角英数字のみで入力してください';

  @override
  String get usernameChanged => 'ユーザー名を変更しました';

  @override
  String get usernameAlreadyChangedBody => 'ユーザー名の変更は一度きりで、すでに使用済みです。';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get camera => 'カメラ';

  @override
  String get orPickOurs => '用意された中から選ぶ';

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
  String get recalibrate => '再調整';

  @override
  String get resetCount => 'カウントをリセット';

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
  String get units => '単位';

  @override
  String get weight => '重量';

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
  String challengeSent(String name) {
    return '$name に挑戦を送りました';
  }

  @override
  String get weightUnitTitle => '重量の単位';

  @override
  String get heightUnitTitle => '身長の単位';

  @override
  String get unitKg => 'キログラム (kg)';

  @override
  String get unitLb => 'ポンド (lb)';

  @override
  String get unitCm => 'センチメートル (cm)';

  @override
  String get unitFt => 'フィート・インチ';

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
  String get needsServer => 'この機能にはサーバーが必要ですが、まだ接続されていません';

  @override
  String get achievements => '実績';

  @override
  String get unlocked => '解放済み';

  @override
  String get roadTitle => 'マスターへの道';

  @override
  String get allTiers => 'すべてのランク';

  @override
  String get topTier => '最上位ランク';

  @override
  String lpToGo(String lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => 'すべて解放済みです';

  @override
  String unlocksAt(String tier) {
    return '$tier で解放';
  }

  @override
  String get roomFriendly => 'ルームマッチは親善戦です。ランクには影響しません。';

  @override
  String get createRoom => 'ルームを作る';

  @override
  String get enterCode => 'コードを入力';

  @override
  String get joinRoom => 'ルームに入る';

  @override
  String get shareThisCode => 'このコードを共有';

  @override
  String get codeCopied => 'コードをコピーしました';

  @override
  String get pickMuscleAndStart => '部位を選んで開始';

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
  String get rewardStone => '60秒デュエル';

  @override
  String get rewardBronze => '再戦ボタン';

  @override
  String get rewardSilver => '時間のカスタム設定';

  @override
  String get rewardGold => '3本勝負';

  @override
  String get rewardPlatinum => 'プライベート大会';

  @override
  String get rewardDiamond => 'オープンロビー';

  @override
  String get rewardMaster => '世界ボードに名前が載る';

  @override
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'ft';

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
  String get mgBack => '背中';

  @override
  String get mgLegs => '脚';

  @override
  String get mgShoulders => '肩';

  @override
  String get mgArms => '腕';

  @override
  String get mgCore => '体幹';

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
  String get addFriend => '追加';

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
  String get local => 'Local';

  @override
  String get weekly => 'Weekly';

  @override
  String get seasonTab => 'Season';

  @override
  String get allTime => 'All-time';

  @override
  String get daily => 'Daily';

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
  String lpToUnlock(String lp, String rank, String unlock) {
    return '$rank まで $lp LP · $unlock が解放';
  }

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
  String get findPeople => '人を探す';

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
  String opponentDisconnected(String name) {
    return '$nameが切断しました';
  }

  @override
  String get forfeitNoMargin => '棄権 · 差はカウントされません';

  @override
  String get findAnotherMatch => '別のマッチを探す';

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
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss LP';
  }

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
  String get yourRankCard => 'あなたのランクカード';

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
  String get obHowTitle => '3つだけ。それで準備完了。';

  @override
  String get obHow1 => 'スマホを床に置く';

  @override
  String get obHow1Body => '1メートル前の壁に立てかける。';

  @override
  String get obHow2 => 'カメラが回数を数える';

  @override
  String get obHow2Body => '1回ごとに深さを判定。浅い回はカウントしない。';

  @override
  String get obHow3 => '誰かと60秒勝負';

  @override
  String get obHow3Body => '勝てば上がる。負ければ下がる。ルールは全員同じ。';

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
  String get obCameraPrivateBody =>
      '姿勢の解析はこの端末で動きます。自分で投稿しない限り、動画はアップロードされません。';

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
  String get obCreateAccountBody => '回数もランクも戦績も残すには、アカウントを作成。';

  @override
  String get obSaveProgress => '記録を保存';

  @override
  String obSaveYourReps(String count) {
    return '$count 回を保存する';
  }

  @override
  String get obOneTap => 'メールアドレスとパスワードだけ。';

  @override
  String get obContinueApple => 'Apple で続ける';

  @override
  String get obContinueGoogle => 'Google で続ける';

  @override
  String get obContinueEmail => 'メールで続ける';

  @override
  String get obSignInFootnote => 'アカウントの維持だけに使います。こちらから投稿することはありません。';

  @override
  String get obPickName => '名前を決める';

  @override
  String get obPickNameBody => '対戦相手に表示される名前です。あとから変更できます。';

  @override
  String get obAvailable => '使える';

  @override
  String get obTaken => '使用済み';

  @override
  String get obYourAvatar => 'アイコン';

  @override
  String get obAddPhoto => '写真を追加';

  @override
  String get obNotifyTitle => '挑まれたらすぐ分かる';

  @override
  String get obNotifyChallenged => '誰かがあなたに挑戦した';

  @override
  String get obNotifyStreak => '連続記録が途切れそう';

  @override
  String get obNotifyPassed => '友だちがランキングであなたを抜いた';

  @override
  String get obTurnOn => 'オンにする';

  @override
  String get obPlacementsBody => '5回の対戦で開始ティアが決まります。まだ負けは記録に響きません。';

  @override
  String get obFindFirstOpponent => '最初の相手を探す';

  @override
  String get obGotIt => 'わかった';

  @override
  String get obFormMixed => 'ばらつきあり';

  @override
  String get obWelcomeBack => 'おかえり';

  @override
  String get obWelcomeBackBody => 'メールアドレスとパスワードでサインインしてください。';

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
  String get lpRowWin => '勝利';

  @override
  String get lpRowLoss => '敗北';

  @override
  String get lpRowOpponent => '相手のランク';

  @override
  String get lpRowMargin => '差';

  @override
  String get lpRowDepth => '深さ';

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
}
