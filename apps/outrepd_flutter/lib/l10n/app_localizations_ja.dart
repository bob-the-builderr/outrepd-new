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
  String get incDuels => 'デュエル履歴とレートの変動';

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
  String get createAccountBody => 'サインインすれば、このアカウントがこの端末だけに頼ることはありません。';

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
  String get removePhoto => '写真を削除';

  @override
  String get removePhotoTitle => '写真を削除しますか？';

  @override
  String get removePhotoBody =>
      '代わりにあなたのリフターがすべての場所に表示されます。新しい写真はいつでも追加できます。';

  @override
  String get removePhotoConfirm => '削除';

  @override
  String get couldNotRemovePhoto => '写真を削除できませんでした。もう一度お試しください。';

  @override
  String get cropPhoto => '切り抜き';

  @override
  String get proGoTitle => 'Proになろう。';

  @override
  String get proOnboardTitle => 'あなたのリフター、Pro。';

  @override
  String get proSubtitle => '広告なし、そして無料版にはない見た目。';

  @override
  String get proFree => '無料';

  @override
  String get proYoursNow => '今のあなた';

  @override
  String get proPerkNoAds => '広告なし。ずっと。';

  @override
  String get proPerkNoAdsBody => 'どの試合も、どのレベルも、途切れずに。';

  @override
  String get proPerkBoard => 'すべてのボードで輝く';

  @override
  String get proPerkBoardBody => 'ホロの行から、あなたのリフターが飛び出す。';

  @override
  String get proPerkEntrance => '稲妻の登場';

  @override
  String get proPerkEntranceBody => 'ライブ対戦の前のVS画面で。';

  @override
  String get proPerkCovers => '9種類の動くカバー';

  @override
  String get proPerkCoversBody => 'または自分の写真を、プロフィールの上に。';

  @override
  String get proPerkItems => 'Pro限定アイテム20種';

  @override
  String get proPerkItemsBody => 'スキン、トップス、ギア、そしてまばたきするリフター。';

  @override
  String get proGo => 'Proになる';

  @override
  String proBuyYearly(String price) {
    return 'Proになる · ${price}/年';
  }

  @override
  String proBuyWeekly(String price) {
    return 'Proになる · ${price}/週';
  }

  @override
  String get proSettingsBody => '広告なし、そしてProの見た目。';

  @override
  String get proSettingsActive => 'あなたはProです。応援ありがとうございます。';

  @override
  String get lifterMakerTitle => 'アバターをカスタマイズ';

  @override
  String get lifterMakerFirst => 'アバターをカスタマイズ';

  @override
  String get lifterMakerFirstBody => 'すべてのボードと試合で、これがあなたです。';

  @override
  String get lifterTabSkin => '肌';

  @override
  String get lifterTabHair => '髪';

  @override
  String get lifterTabFace => '顔';

  @override
  String get lifterTabBeard => 'ひげ';

  @override
  String get lifterTabTop => 'トップス';

  @override
  String get lifterTabGear => 'ギア';

  @override
  String get lifterTabBackground => '背景';

  @override
  String get lifterEyes => '目';

  @override
  String get lifterBrows => '眉';

  @override
  String get lifterMouth => '口';

  @override
  String get lifterMarks => 'マーク';

  @override
  String get lifterRandom => 'ランダム';

  @override
  String get lifterTryingPro => 'Proの見た目。';

  @override
  String get lifterUnlockPro => 'Proで解放';

  @override
  String get editLifter => 'リフターを編集';

  @override
  String lifterNeedsWorld(String world) {
    return '${world}をクリア';
  }

  @override
  String lifterNeedsTier(String tier) {
    return '${tier}に到達';
  }

  @override
  String lifterNeedsLevel(String level) {
    return 'レベル${level}に到達';
  }

  @override
  String lifterNeedsWins(String count) {
    return '${count}試合に勝つ';
  }

  @override
  String lifterNeedsWinStreak(String count) {
    return '${count}連勝する';
  }

  @override
  String lifterNeedsDayStreak(String count) {
    return '${count}日連続でトレーニング';
  }

  @override
  String get lifterNeedsMonthTop10 => '月間トップ10で終える';

  @override
  String get lifterNeedsMonthPodium => '月間トップ3で終える';

  @override
  String get lifterNeedsMonthChampion => '月間1位になる';

  @override
  String lifterNeedsStars(String count) {
    return '${count}個のアドベンチャーレベルで星3つ';
  }

  @override
  String get lifterNeedsAllStars => 'アドベンチャーのすべての星';

  @override
  String get coverTitle => 'カバー';

  @override
  String get coverPhoto => '自分の写真';

  @override
  String get coverNone => 'カバーなし';

  @override
  String get coverUse => 'このカバーにする';

  @override
  String get coverProLine => 'カバーはPro限定です。動いて、あなたのプロフィールを開いた全員に見えます。';

  @override
  String get coverCouldNotUpload => '写真をアップロードできませんでした。もう一度お試しください。';

  @override
  String get coverNeonCity => 'ネオンシティ';

  @override
  String get coverIronGym => 'アイアンジム';

  @override
  String get coverRooftopSunset => '屋上の夕暮れ';

  @override
  String get coverStadiumLights => 'スタジアムの照明';

  @override
  String get coverSilverPeaks => '銀の峰';

  @override
  String get coverBronzeDunes => 'ブロンズの砂丘';

  @override
  String get coverVolcano => '火山';

  @override
  String get coverPalmBeach => 'パームビーチ';

  @override
  String get coverWinterCity => '冬の街';

  @override
  String get vsLiveRanked => 'ライブ · ランク戦';

  @override
  String get vsLiveFriendly => 'ライブ · フレンド戦';

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
  String get usernameAlreadyChangedBody => 'ユーザー名は14日に1回変更できます。';

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
    return '${n} 週間前';
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
  String get noRanksYet => 'まだランキングがありません';

  @override
  String get noRanksYetBody => '対戦するとボードが埋まっていきます。';

  @override
  String get ranksTitle => 'ランク';

  @override
  String get totalReps => '合計回数';

  @override
  String get recent => '最近';

  @override
  String wonVs(String name) {
    return '${name}に勝利';
  }

  @override
  String lostVs(String name) {
    return '${name}に敗北';
  }

  @override
  String hoursAgo(String n) {
    return '${n}時間前';
  }

  @override
  String toNextTier(String n, String tier) {
    return '${tier}まで${n}';
  }

  @override
  String get noMatchesYet => 'まだ対戦がありません';

  @override
  String get noMatchesYetBody => '最初の対戦は勝っても負けてもここに表示されます。';

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
  String get yourRank => 'あなたのランク';

  @override
  String get whoIsNext => '次の相手は？';

  @override
  String get opponentFound => '対戦相手が見つかりました';

  @override
  String ratingFloor(String n) {
    return 'レートが${n}を下回ることはありません。';
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
  String get noRankYet => 'まだランクなし';

  @override
  String get unranked => 'ランクなし';

  @override
  String get practiceFirst => 'まず練習';

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
  String get noConnectionBody => '対戦には接続が必要です。アドベンチャーはオフラインでも遊べ、回数はあとで同期されます。';

  @override
  String get getBackInFrame => '画面に戻って';

  @override
  String get clockStillRunning => '時間は進んでいます。カウントは止まっています。';

  @override
  String get giveUp => '棄権';

  @override
  String get lpMovesWithGap => '勝利：+25とレップ差。敗北：−20とレップ差。';

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
  String get obCheckHandsFeet => '頭・肩・手がフレームに入っている';

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
      '練習セットの後に回数を確認するたび、そのセットがあなたの申告と照らし合わされます。結果はここに出ます。';

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
      '1回ごとに、どこまで下がってどこまで上がり直したかで判定します。それを見られるのはカメラだけです。カメラがなければカウントできず、カウントがなければ対戦もできません。カメラが動くのはセット中だけです。';

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
  String get signOutBody => 'アカウントはランク、履歴、サブスクリプションごとそのまま残ります。いつでも同じ方法でサインインし直せます。';

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
  String get dailyReminderHint => '目標をまだ達成していない日だけ。';

  @override
  String get reminderTime => '時刻';

  @override
  String get reminderTitle => '今日の腕立て伏せの時間です';

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
  String get onlineNow => 'オンライン';

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
    return '${name} が開始に間に合いませんでした。記録は残りません。';
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
  String get awardRegular => '20クラブ';

  @override
  String monthToTop10(String lp) {
    return 'トップ10まであと${lp} pt';
  }

  @override
  String monthIfEndedNow(String award) {
    return '今月が今終われば${award}';
  }

  @override
  String get monthJoinHint => 'ランク戦を1回やると今月のボードに載ります';

  @override
  String monthRegularProgress(String progress) {
    return '20クラブバッジ · ランク戦 ${progress}';
  }

  @override
  String get monthRegularEarned => '今月の20クラブバッジを獲得';

  @override
  String get monthEmptyTitle => '新しい月';

  @override
  String get monthEmptyBody => '今月はまだ誰もポイントを獲得していません。最初のランク戦に勝てば首位です。';

  @override
  String get weekEmptyTitle => '新しい週';

  @override
  String get weekEmptyBody => '今週はまだ誰もポイントを獲得していません。最初のランク戦に勝てば首位です。';

  @override
  String get ratingUnit => 'レート';

  @override
  String get ptsUnit => 'pt';

  @override
  String ptsAmount(String n) {
    return '${n} pt';
  }

  @override
  String ratingAmount(String n) {
    return 'レート ${n}';
  }

  @override
  String ratingForWin(String n) {
    return '勝利で${n}';
  }

  @override
  String ratingForLoss(String n) {
    return '敗北で${n}';
  }

  @override
  String ratingForReps(String n) {
    return 'レップ差で${n}';
  }

  @override
  String get boardThisWeek => '今週';

  @override
  String get boardOverall => '総合';

  @override
  String get howPointsWork => 'ポイントのしくみ';

  @override
  String streakNextTen(String n) {
    return '${n}連勝中：次の勝利は+10';
  }

  @override
  String get boardRuleWin => '勝利 +5';

  @override
  String get boardRuleLoss => '敗北 −2';

  @override
  String get boardRuleStreak => '3連勝で +10';

  @override
  String rankNext(String rank) {
    return '次：${rank}';
  }

  @override
  String rankAt(String n) {
    return '${n}で到達';
  }

  @override
  String toGo(String n) {
    return 'あと${n}';
  }

  @override
  String tierStartsAt(String tier, String n) {
    return '${tier}は${n}から';
  }

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
  String monthWinners(String month) {
    return '${month}の勝者';
  }

  @override
  String get playShort => 'プレイ';

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

  @override
  String liveOnlineNow(String n) {
    return '${n}人がオンライン';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n}人が検索中';
  }

  @override
  String get dailyGoalTitle => '今日の目標';

  @override
  String get dailyGoalDone => '今日は達成';

  @override
  String dailyGoalProgress(String progress) {
    return '腕立て ${progress}';
  }

  @override
  String dailyGoalLeft(String n) {
    return 'あと${n}';
  }

  @override
  String get dailyGoalChange => '変更';

  @override
  String get dailyGoalPick => '1日の目標';

  @override
  String dailyGoalOption(String n) {
    return '1日${n}回';
  }

  @override
  String widgetGoalOf(String goal) {
    return '今日の目標 ${goal}';
  }

  @override
  String get saveToAppleHealth => 'ワークアウトをAppleヘルスケアに保存';

  @override
  String get saveToHealthConnect => 'ワークアウトをヘルスコネクトに保存';

  @override
  String get saveToHealthHint => 'セットごとに筋力トレーニングとして追加されます。読み取りは行いません。';

  @override
  String get healthNotAllowed => 'まだ許可されていません。スマホのヘルスケア設定で許可できます。';

  @override
  String reminderLeft(String count) {
    return '今日の目標まであと${count}回。';
  }

  @override
  String get liveInviteHint => 'オンラインの友達はすぐに参加できます。それ以外の友達には通知が届き、1分以内に参加できます。';

  @override
  String get requestSentShort => 'リクエスト送信済み';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPDは${health}と連携します';
  }

  @override
  String healthCardBody(String health) {
    return '終えたセットはすべて筋力トレーニングとして${health}に保存されます。OUTREPDがあなたのヘルスケアデータを読み取ることはありません。';
  }

  @override
  String savedToHealth(String health) {
    return '${health}に保存しました';
  }

  @override
  String get usernameTooShort => '短すぎます：4文字以上にしてください';

  @override
  String get usernameBadCharacters => '使えるのは英数字と _ のみです';

  @override
  String get usernameNeedsLetter => '英字か数字を1つ以上入れてください';

  @override
  String usernameChangeAgainOn(String date) {
    return '${date}にまた変更できます';
  }

  @override
  String get continueWithApple => 'Appleで続ける';

  @override
  String get continueWithGoogle => 'Googleで続ける';

  @override
  String get socialSignInFailed => 'サインインできませんでした。もう一度お試しください。';

  @override
  String get chooseUsernameTitle => 'ユーザー名を選んでください';

  @override
  String get chooseUsernameSubtitle => 'ほかのユーザーがあなたを見つけたり、ランキングで見たりするための名前です。';

  @override
  String get authHeroTitle => '誰にでも勝て。';

  @override
  String get authHeroSubtitle => 'ライブの腕立て対決。数えるのはあなたのカメラ。';

  @override
  String get createAccountPitch => 'ランクも対戦も、どのスマホでも。';

  @override
  String get usernameSpacesHint => 'スペースは _ になります';

  @override
  String get emailCodeNote => '6桁のコードをメールでお送りします。パスワードは不要です。';

  @override
  String get continueWithEmail => 'メールで続ける';

  @override
  String get thisSeason => '今シーズン';

  @override
  String get thisWeek => '今週';

  @override
  String get weekStartsAgain => '毎週月曜日にリセット';

  @override
  String get lengthWeek => '週';

  @override
  String get lengthMonth => '月';

  @override
  String get weekJoinHint => '今週ランク戦で1勝すると掲載されます';

  @override
  String get weekInTop3 => '今週トップ3入り';

  @override
  String weekToTop3(String n) {
    return 'トップ3まであと${n} pt';
  }

  @override
  String get boardActiveNote => '過去30日間にプレイした人';

  @override
  String get boardTieNote => '同点なら勝利数が多い方が上';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return '回数差で${reps} · ${rank}の相手で${adjust}';
  }

  @override
  String levelShort(String n) {
    return 'Lv.${n}';
  }

  @override
  String xpOf(String into, String span) {
    return '${into} / ${span} XP';
  }

  @override
  String xpToLevel(String n, String level) {
    return 'レベル ${level} まであと ${n} XP';
  }

  @override
  String xpHow(String rep, String match) {
    return '1回ごとに ${rep} XP、勝利ごとに ${match}、負けは 0';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return '回数で ${n}';
  }

  @override
  String xpForMatch(String n) {
    return 'マッチで ${n}';
  }

  @override
  String get levelUp => 'レベルアップ';

  @override
  String get levelUpBody => '1回1回が積み重なる。この調子で。';

  @override
  String giveUpAhead(String n) {
    return '${n}回リード中';
  }

  @override
  String giveUpBehind(String n) {
    return '${n}回ビハインド';
  }

  @override
  String get giveUpTied => '同点';

  @override
  String get keepGoing => '続ける';

  @override
  String get stay => '残る';

  @override
  String lastN(String n) {
    return '直近${n}試合';
  }

  @override
  String get firstMatchForTier => '最初のマッチをプレイするとランキングに参加できます。全員 Iron V からスタートです。';

  @override
  String get firstMatchForBoard => '最初のマッチをプレイするとランキングに載ります。全員 Iron V からスタートです。';

  @override
  String get playFirstMatch => '最初のマッチをプレイ';

  @override
  String firstMatchTerms(String seconds) {
    return '1マッチ · ${seconds}秒';
  }

  @override
  String get placedLabel => 'ランキングに参加しました';

  @override
  String get placedBody => '全員ここからスタート。勝つことでしか上がれません。';

  @override
  String get placedHow => '勝利：+25とレップ差。敗北：−20とレップ差。';

  @override
  String get levelBesideName => 'あなたの名前の横に、どこでも';

  @override
  String get weekRaceTitle => '今週のレース';

  @override
  String get streakDoneToday => '今日は達成';

  @override
  String get streakTrainToday => '今日やれば1日追加';

  @override
  String get raceChartTitle => '1分間の流れ';

  @override
  String raceYouLead(String time) {
    return '${time} · あなたがリード';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} がリード';
  }

  @override
  String get bringFriendTitle => '友だちを誘おう';

  @override
  String get bringFriendBody => 'リンクを送ろう。あなたのプロフィールが開き、そこから追加してもらえます。';

  @override
  String get bringFriendShare => 'リンクを共有';

  @override
  String get bringFriendShareText => 'OUTREPDで腕立て伏せ勝負しよう。60秒、ライブ、カメラがカウント。';

  @override
  String orFriendCode(String code) {
    return 'またはフレンドコード ${code}';
  }

  @override
  String get countryPickerTitle => 'あなたの国';

  @override
  String get countrySearch => '検索';

  @override
  String get countryFromPhone => 'スマホの設定から';

  @override
  String get countryAll => 'すべての国';

  @override
  String get countryChoose => '国を選ぶ';

  @override
  String get countryChange => '変更';

  @override
  String get countryForBoard => 'あなたの国のランキング用';

  @override
  String get countryLabel => '国';

  @override
  String get countryChanged => '国を変更しました';

  @override
  String get countryEvery14 => '名前と同じく14日に1回';

  @override
  String get countryNotSaved => '国を保存できませんでした。もう一度お試しください。';

  @override
  String get adventure => 'アドベンチャー';

  @override
  String stageNumber(String n) {
    return 'ステージ${n}';
  }

  @override
  String adventureLevelIn(String level, String world) {
    return 'ステージ${level} · ${world}';
  }

  @override
  String adventureClearedOf(String cleared, String total) {
    return '${total}中${cleared}クリア · ランクなし';
  }

  @override
  String get worldIron => 'アイアン鉱山';

  @override
  String get worldBronze => 'ブロンズ砂丘';

  @override
  String get worldSilver => 'シルバー山脈';

  @override
  String get worldGold => 'ゴールド城塞';

  @override
  String get worldPlatinum => 'プラチナ氷河';

  @override
  String get worldDiamond => 'ダイヤモンド洞窟';

  @override
  String get worldMaster => 'マスターの玉座';

  @override
  String worldNumber(String n) {
    return 'ワールド${n}';
  }

  @override
  String fightLevel(String level) {
    return 'ステージ${level}に挑む';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · 腕立て約${reps}回';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return 'コンボ ×${n}';
  }

  @override
  String get levelCleared => 'クリア';

  @override
  String get outOfTime => 'タイムアップ';

  @override
  String get statPushUps => '腕立て';

  @override
  String get statTimeLeft => '残り';

  @override
  String get statHpLeft => '残りHP';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return '残り${seconds}秒以上でクリアすると星2つ';
  }

  @override
  String thirdStarHint(String seconds) {
    return '残り${seconds}秒以上でクリアすると星3つ';
  }

  @override
  String get fightLostHint => '前のステージで星を集めよう。星でもっと強い武器が手に入る。';

  @override
  String get nextLevel => '次のステージ';

  @override
  String get tryAgain => 'もう一度';

  @override
  String get adventureMap => 'マップ';

  @override
  String get nextKicker => '次';

  @override
  String nextLevelLine(String level, String hp) {
    return 'ステージ${level} · HP ${hp}';
  }

  @override
  String get armory => '武器庫';

  @override
  String get armoryBody => '星で武器が解放される。各ワールドの敵には、そのワールドの武器以上でしかダメージを与えられない。';

  @override
  String get equipped => '装備中';

  @override
  String perPushUp(String damage) {
    return '1回${damage}';
  }

  @override
  String damagePerPushUp(String damage) {
    return '腕立て1回で${damage}ダメージ';
  }

  @override
  String wasWith(String damage, String weapon) {
    return 'これまで：${weapon}で${damage}';
  }

  @override
  String moreStars(String count) {
    return 'あと星${count}個';
  }

  @override
  String get newWeapon => '新しい武器';

  @override
  String starsKicker(String count) {
    return '星${count}個';
  }

  @override
  String get weaponGauntlets => 'アイアンガントレット';

  @override
  String get weaponKnuckles => 'ブロンズナックル';

  @override
  String get weaponFang => 'シルバーファング';

  @override
  String get weaponHammer => 'ゴールドハンマー';

  @override
  String get weaponAxe => 'プラチナアックス';

  @override
  String get weaponSpear => 'ダイヤモンドスピア';

  @override
  String get weaponSword => 'マスターソード';

  @override
  String get weaponCrownbreaker => 'クラウンブレイカー';

  @override
  String clearFirst(String level) {
    return 'まずステージ${level}をクリアしよう';
  }

  @override
  String needsWeapon(String weapon) {
    return '${weapon}が必要';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return '${weapon}以上の武器でしかダメージを与えられない';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world}には${weapon}が必要 · あと星${count}個';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name}が退出しました · 今回は再戦なし';
  }

  @override
  String get obNext => '次へ';

  @override
  String get obRaceTitle => '本物の相手と競う。';

  @override
  String get obRaceBody => '60秒で回数が多い方の勝ち。相手は自分のスマホからライブで参加。誰もオンラインでなければ、録画されたセットと勝負します。';

  @override
  String get obRepsTitle => '数えるのはフルレップだけ。';

  @override
  String get obRepsBody => 'カメラが、どこまで下がってどこまで戻ったかを見ています。';

  @override
  String get obRepsDown => '金のラインより下まで';

  @override
  String get obRepsUp => '上のラインより上まで戻る';

  @override
  String get obRepsBoth => 'どちらも手を床につけたまま。半端なレップは数えません。あなたのスマホでも、相手のスマホでも。';

  @override
  String get obClimbTitle => 'Masterを目指そう。';

  @override
  String get obClimbBody => '7つのティア、それぞれ5段階。勝って上がり、負けると1つ下がることも。ただし1,000ポイントを下回ることはありません。';

  @override
  String get obGoldLine => '金のライン';

  @override
  String obCalibrationRule(String gold) {
    return '${gold}より下まで下げて、上のラインより上まで戻る';
  }

  @override
  String get proThanks => '広告をオフにしました。Proへようこそ。';

  @override
  String get adAskTitle => '広告でoutrepdは無料です';

  @override
  String get adAskBody => 'このあとiPhoneが、広告選びのためにアプリがあなたのアクティビティを使ってよいか尋ねます。許可すると広告があなた向けになり、許可しなくても広告は出ますが、関連性が低くなります。';

  @override
  String get adAskCamera => 'カメラは関係ありません。どちらを選んでも、体のトラッキングはこのスマホの中だけで行われます。';

  @override
  String get monsterIronColossus => 'アイアンコロッサス';

  @override
  String get monsterScarab => 'スカラベ';

  @override
  String get monsterScarabPharaoh => 'スカラベファラオ';

  @override
  String get monsterYeti => 'イエティ';

  @override
  String get monsterFrostYeti => 'フロストイエティ';

  @override
  String get monsterYetiChieftain => 'イエティの族長';

  @override
  String get monsterGoldSoldier => 'ゴールドソルジャー';

  @override
  String get monsterGoldKnight => 'ゴールドナイト';

  @override
  String get monsterGoldKing => 'ゴールドキング';

  @override
  String get monsterWisp => 'ウィスプ';

  @override
  String get monsterWraith => 'レイス';

  @override
  String get monsterFrostLich => 'フロストリッチ';

  @override
  String get monsterCrystalDrake => 'クリスタルドレイク';

  @override
  String get monsterCrystalDragon => 'クリスタルドラゴン';

  @override
  String get monsterDiamondWyrm => 'ダイヤモンドワーム';

  @override
  String get monsterShadowGuard => 'シャドウガード';

  @override
  String get monsterShadowKnight => 'シャドウナイト';

  @override
  String get monsterTheMaster => 'ザ・マスター';

  @override
  String get monsterPebbleGolem => 'ペブルゴーレム';

  @override
  String get monsterStoneGolem => 'ストーンゴーレム';

  @override
  String get monsterOreGolem => 'オアゴーレム';

  @override
  String get monsterMinerGolem => 'マイナーゴーレム';

  @override
  String get monsterScarabGrub => 'スカラベの幼虫';

  @override
  String get monsterHornedScarab => 'ツノスカラベ';

  @override
  String get monsterScarabWarrior => 'スカラベウォリアー';

  @override
  String get monsterYetiCub => '子イエティ';

  @override
  String get monsterHornedYeti => 'ツノイエティ';

  @override
  String get monsterGoldRecruit => 'ゴールドリクルート';

  @override
  String get monsterGoldGuard => 'ゴールドガード';

  @override
  String get monsterShade => 'シェイド';

  @override
  String get monsterIceSpecter => 'アイススペクター';

  @override
  String get monsterCrystalHatchling => 'クリスタルの幼竜';

  @override
  String get monsterCrystalWhelp => 'クリスタルの若竜';

  @override
  String get monsterShadowSquire => 'シャドウスクワイア';

  @override
  String get monsterShadowLord => 'シャドウロード';

  @override
  String monsterWarden(String name) {
    return '${name}・番人';
  }

  @override
  String get obPhoneSees => 'スマホに映るべき姿';

  @override
  String get obPhoneSeesBody => '頭のてっぺんから手まで、約1メートル離れて、腕立ての姿勢で。';

  @override
  String get obUnder13 => '13歳未満';

  @override
  String get obOver13 => '13歳以上';

  @override
  String get obFor13 => 'outrepdは13歳以上向けです。';

  @override
  String get obUnder13Blocked => 'outrepdは13歳以上向けです。13歳になったらまた来てね。腕立てはここで待っています。';

  @override
  String get obBeforeYouLift => '始める前に';

  @override
  String get obFightTitle => 'モンスターと戦おう。';

  @override
  String get obFightBody => '7つのワールドで140の腕立て伏せバトル。1回ごとにモンスターにダメージ。';

  @override
  String obSevenWorlds(String from, String to) {
    return '7つのワールド：${from}から${to}まで';
  }

  @override
  String get obWeaponsTitle => '星で武器をアンロック';

  @override
  String get obWeaponsBody => 'ワールドごとに専用の武器が必要。ランクは変動しません。';

  @override
  String get fightDefeated => '撃破！';

  @override
  String get nextWeapon => '次の武器';

  @override
  String opensWorld(String world) {
    return '${world}が開く';
  }

  @override
  String weaponAtStars(String count) {
    return '星${count}個で';
  }

  @override
  String topTenIn(String country) {
    return '${country}でトップ10';
  }
}
