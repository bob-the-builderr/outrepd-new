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
  String get tabCrew => 'クルー';

  @override
  String get tabProfile => 'プロフィール';

  @override
  String get searchOpponent => '対戦相手を探す';

  @override
  String get searchOpponentHint => '同じランクの相手とマッチングします';

  @override
  String get challengeFriend => 'フレンドに挑む';

  @override
  String get trainWithCamera => 'カメラでトレーニング';

  @override
  String get viewRoadmap => 'ロードマップを見る';

  @override
  String lpProgress(int lp, int left) {
    return '$lp / 100 LP · 昇格まであと $left';
  }

  @override
  String winStreak(int count) {
    return '$count 連勝中';
  }

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
  String get profile => 'プロフィール';

  @override
  String get settings => '設定';

  @override
  String get stats => '記録';

  @override
  String get edit => '編集';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get skip => 'スキップ';

  @override
  String get totalMatches => '総マッチ数';

  @override
  String get bestWinStreak => '最高連勝数';

  @override
  String get totalVolume => '総挙上重量';

  @override
  String get height => '身長';

  @override
  String get bodyweight => '体重';

  @override
  String get age => '年齢';

  @override
  String get editYourStats => '自分のデータを編集';

  @override
  String get editStatsHint => '勝利・挙上量・ランクは勝ち取るもので、書き換えるものではありません。';

  @override
  String get changeName => '名前を変更';

  @override
  String get changeNameLast => 'これが最後の変更です。取り消せません。';

  @override
  String changeNameLeft(int total, int left) {
    return '変更は全部で $total 回まで。今回のあと残り $left 回です。';
  }

  @override
  String get changeNameUsedUp => '名前の変更は2回とも使い切りました';

  @override
  String get yourPicture => 'あなたの写真';

  @override
  String get yourPictureHint => 'フレームはランクによって決まり、昇格すると変わります。';

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
  String titlesAndStreak(int owned, int total, int streak) {
    return '$total 個中 $owned 個 · $streak 日連続';
  }

  @override
  String get crew => 'クルー';

  @override
  String get myCrew => '自分のクルー';

  @override
  String get rankings => 'ランキング';

  @override
  String get trainWithCrew => 'クルーで鍛える';

  @override
  String get trainWithCrewHint => 'ひとつの名前のもとに最大20人。週の目標をいっしょに追い、クルー表を駆け上がります。';

  @override
  String get createCrew => 'クルーを作る';

  @override
  String get createCrewHint => '名前をつけ、エンブレムを選び、仲間を誘う';

  @override
  String get joinOpenCrew => 'オープンなクルーに入る';

  @override
  String get joinOpenCrewHint => '誰でも参加できるクルーです';

  @override
  String get yourInvites => '届いた招待';

  @override
  String get yourInvitesHint => 'あなたを指名したクルー';

  @override
  String get joinWithCode => 'コードで参加';

  @override
  String get joinWithCodeHint => 'メンバーからもらう6文字';

  @override
  String get topCrewsThisWeek => '今週の上位クルー';

  @override
  String get members => 'メンバー';

  @override
  String get repsEach => '1人あたりレップ';

  @override
  String get rank => '順位';

  @override
  String get weeklyGoal => '週の目標';

  @override
  String get weeklyGoalDone => '週の目標を達成';

  @override
  String goalRemaining(int reps, int days) {
    return '残り $reps レップ · あと $days 日';
  }

  @override
  String get goalDoneHint => '週が終わればバッジは全員に届きます。';

  @override
  String get startCrewWar => 'クルー戦を始める';

  @override
  String get startCrewWarHint => '7日間、両クルーがカウント。1人あたりのレップが多いほうの勝ちです。';

  @override
  String get whoIsPulling => 'クルーを支えているメンバー';

  @override
  String get thisWeek => '今週';

  @override
  String get inviteLifters => '仲間を招待';

  @override
  String get referralCode => '招待コード';

  @override
  String get inviteLink => '招待リンク';

  @override
  String get leaveCrew => 'クルーを抜ける';

  @override
  String get owner => 'オーナー';

  @override
  String get crewTable => 'クルー表';

  @override
  String get repsPerMember => '1人あたりレップ';

  @override
  String seasonResets(int days) {
    return '$days 日後にリセット — 全員が同じ位置から';
  }

  @override
  String get rankingExplained =>
      'クルーの順位は合計ではなく1人あたりのレップで決まります。合計だと人数の多いクルーが数だけで勝ってしまうからです。';

  @override
  String get leaderboard => 'ランキング';

  @override
  String get global => '世界';

  @override
  String get myCountry => '自分の国';

  @override
  String yourFriends(String count) {
    return 'フレンド ($count)';
  }

  @override
  String get challenge => '挑む';

  @override
  String get notifications => '通知';

  @override
  String get pickMovement => '種目を選ぶ';

  @override
  String get anyExercise => '種目おまかせ';

  @override
  String get anyExerciseHint => 'セットを開始してください。動作は実行中に判別されます';

  @override
  String get start => '開始';

  @override
  String get finish => '終了';

  @override
  String get reps => 'レップ';

  @override
  String get secondsHeld => '秒キープ';

  @override
  String get learningMovement => '動きを学習中 — まもなくカウントが出ます';

  @override
  String get recalibrate => '再調整';

  @override
  String get resetCount => 'カウントをリセット';

  @override
  String get checksForm => 'フォームを判定';

  @override
  String get counts => 'カウント対象';

  @override
  String get time => '時間';

  @override
  String get howManyReally => '実際は何回でしたか？';

  @override
  String get howManyReallyHint => 'アプリではなくあなた自身の数です。あとでカウンターの精度を測る基準になります。';

  @override
  String get appearance => '外観';

  @override
  String get theme => 'テーマ';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get language => '言語';

  @override
  String get units => '単位';

  @override
  String get weight => '重量';

  @override
  String get notificationsSection => '通知';

  @override
  String get privacy => 'プライバシー';

  @override
  String get matches => 'マッチ';

  @override
  String get data => 'データ';

  @override
  String get about => 'このアプリについて';

  @override
  String get dangerZone => '取り扱い注意';

  @override
  String get themeSystem => '端末に合わせる';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get openCrews => 'オープンなクルー';

  @override
  String get openCrewsHint => '誰でも入れます。選べばそのまま参加できます。';

  @override
  String get yourInvitesSubtitle => 'あなたを名指しで誘ったクルーです。';

  @override
  String get pickOpponent => '相手を選ぶ';

  @override
  String get accept => '承認';

  @override
  String get join => '参加';

  @override
  String get copy => 'コピー';

  @override
  String get copied => '招待リンクをコピーしました';

  @override
  String season(String name) {
    return 'シーズン $name';
  }

  @override
  String challengeSent(String name) {
    return '$name に挑戦を送りました';
  }

  @override
  String get inviteFriendPrivate => 'フレンドをプライベートマッチに誘う';

  @override
  String get joinWithCodePaste => 'メンバーから届いた6文字を貼り付けてください。';

  @override
  String get enterTheCode => '6文字のコードを入力してください';

  @override
  String get followingDevice => '現在は端末の設定に合わせています';

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
  String get visEveryoneHint => '誰でもプロフィールを開けます';

  @override
  String get visFriendsHint => '追加した相手だけ';

  @override
  String get visNobodyHint => 'プロフィールは非公開のままです';

  @override
  String get matchInvites => 'マッチの招待';

  @override
  String get matchResults => 'マッチの結果';

  @override
  String get friendRequestsLabel => 'フレンド申請';

  @override
  String get crewActivity => 'クルーの動き';

  @override
  String get rankChanges => 'ランクの変動';

  @override
  String get weeklySummary => '週間まとめ';

  @override
  String get soundLabel => 'サウンド';

  @override
  String get vibration => 'バイブレーション';

  @override
  String get whoCanSeeProfile => 'プロフィールを見られる範囲';

  @override
  String get profileVisibility => 'プロフィールの公開範囲';

  @override
  String get showOnLeaderboards => 'ランキングに表示する';

  @override
  String get allowMatchInvites => 'マッチの招待を受け取る';

  @override
  String get allowFriendRequests => 'フレンド申請を受け取る';

  @override
  String get showHeightWeight => '身長と体重を表示';

  @override
  String get showHeightWeightHint => 'オフにすると身体データは自分だけのものになります';

  @override
  String get autoAcceptFriends => 'フレンドからは自動で承認';

  @override
  String get restTimerBetweenSets => 'セット間のインターバルタイマー';

  @override
  String get exportData => 'データを書き出す';

  @override
  String get clearCache => 'キャッシュを削除';

  @override
  String get cacheCleared => 'キャッシュを削除しました';

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
  String get resetProgress => '進捗をリセット';

  @override
  String get resetProgressTitle => '進捗をリセットしますか？';

  @override
  String get resetProgressBody => 'ランク・LP・マッチ履歴がすべてゼロに戻ります。取り消せません。';

  @override
  String get actionReset => 'リセット';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountTitle => 'アカウントを削除しますか？';

  @override
  String get deleteAccountBody => 'プロフィール、クルー、これまでのマッチがすべて完全に削除されます。';

  @override
  String get actionDelete => '削除';

  @override
  String get needsServer => 'この機能にはサーバーが必要ですが、まだ接続されていません';

  @override
  String get getStarted => 'はじめる';

  @override
  String get skipToApp => 'そのままアプリへ';

  @override
  String get achievements => '実績';

  @override
  String get unlocked => '解放済み';

  @override
  String get roadTitle => 'レジェンドへの道';

  @override
  String get allTiers => 'すべてのランク';

  @override
  String get topTier => '最上位ランク';

  @override
  String lpToGo(int lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => 'すべて解放済みです';

  @override
  String unlocksAt(String tier) {
    return '$tier で解放';
  }

  @override
  String get matchedSameGroup => '同じ部位を鍛えている相手とマッチングされます。';

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
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'ストーン';

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
  String get tierMythic => 'ミシック';

  @override
  String get tierLegend => 'レジェンド';

  @override
  String get rewardStone => 'ストーンの枠';

  @override
  String get rewardBronze => 'ブロンズバッジ';

  @override
  String get rewardSilver => 'シルバーバッジ';

  @override
  String get rewardGold => 'ゴールドバッジ';

  @override
  String get rewardPlatinum => 'プラチナバッジ';

  @override
  String get rewardDiamond => 'ダイヤモンドバッジ';

  @override
  String get rewardMaster => 'マスターバッジ';

  @override
  String get rewardMythic => 'ミシックバッジ';

  @override
  String get rewardLegend => 'レジェンドバッジ';

  @override
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'ft';

  @override
  String winLoss(int w, int l) {
    return '$w勝 $l敗';
  }

  @override
  String get yearsSuffix => '歳';

  @override
  String get yourCrew => 'あなたのクルー';

  @override
  String get crewName => 'クルー名';

  @override
  String get motto => 'モットー';

  @override
  String get mottoHint => 'このクルーは何を掲げますか？';

  @override
  String get country => '国';

  @override
  String get whoCanJoin => '参加できる人';

  @override
  String get minimumRank => '最低ランク';

  @override
  String get anyone => '誰でも';

  @override
  String get emblem => 'エンブレム';

  @override
  String get colour => 'カラー';

  @override
  String get createCrewButton => 'クルーを作成';

  @override
  String get ownerNote => 'あなたがオーナーになります。クルーは最大20名までです。';

  @override
  String get searchCountries => '国を検索';

  @override
  String get noCountryMatch => '該当する国がありません';

  @override
  String get nameTooShort => 'クルー名は3文字以上で入力してください';

  @override
  String get privOpen => 'オープン';

  @override
  String get privRequest => '参加申請';

  @override
  String get privInviteOnly => '招待制';

  @override
  String get privOpenHint => 'コードを持っていればそのまま参加できます';

  @override
  String get privRequestHint => '申請すると管理者が承認します';

  @override
  String get privInviteOnlyHint => '直接の招待でのみ参加できます';

  @override
  String get embStrength => '力';

  @override
  String get embCombat => '戦闘';

  @override
  String get embBeasts => '獣';

  @override
  String get embElements => '元素';

  @override
  String get embHonours => '栄誉';

  @override
  String get embSymbols => 'シンボル';

  @override
  String get ob1Title => 'すべてのセッションを\n勝負に変える';

  @override
  String get ob1Body => 'トレーニングを記録して、同じ部位を鍛えている相手と真っ向から競います。';

  @override
  String get ob2Title => 'フレンドに\n挑む';

  @override
  String get ob2Body => 'プライベートな招待を送り、どちらが本気で鍛えているか決着をつけましょう。';

  @override
  String get ob3Title => 'ランクを駆け上がる';

  @override
  String get ob3Body => '勝つたびに LP が入ります。ストーンからレジェンドまで登りきりましょう。';

  @override
  String get ob4Title => 'ひとりの努力は\n続きにくい';

  @override
  String get ob4Body => '誰も見ていないと、最後のセットを切り上げたくなるものです。';

  @override
  String get ob5Title => 'レジェンドに\nなる';

  @override
  String get ob5Body => '継続は積み重なります。足を運び、上回り、駆け上がる。';

  @override
  String get letsGo => 'はじめよう';

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
  String get ttl_bronze_tier => '石を脱する';

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
  String get ttl_mythic_tier => 'ミシック';

  @override
  String get tdesc_mythic_tier => 'ミシックに到達';

  @override
  String get ttl_legend_tier => 'レジェンド';

  @override
  String get tdesc_legend_tier => 'レジェンドに到達';

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
  String get ttl_iron_hold => 'アイアンホールド';

  @override
  String get tdesc_iron_hold => 'プランクを2分キープ';

  @override
  String get ttl_statue => '彫像';

  @override
  String get tdesc_statue => 'プランクを5分キープ';

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
  String get ttl_joined_up => '加入';

  @override
  String get tdesc_joined_up => 'クルーに所属する';

  @override
  String get ttl_backbone => '屋台骨';

  @override
  String get tdesc_backbone => '4週連続でクルーの首位に立つ';

  @override
  String get ttl_cornerstone => '礎';

  @override
  String get tdesc_cornerstone => '12週連続でクルーの首位に立つ';

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
  String get finish2 => '完了';

  @override
  String get qExperience => 'トレーニングの経験は\nどのくらいですか？';

  @override
  String get expBeginner => '初心者 – やってみたことがある';

  @override
  String get expIntermediate => '中級者 – 定期的に鍛えている';

  @override
  String get expAdvanced => '上級者 – 何年も続けている';

  @override
  String get qGoal => 'いちばんの目標は\n何ですか？';

  @override
  String get goalStronger => 'もっと強くなる';

  @override
  String get goalConsistent => 'もっと継続できるようになる';

  @override
  String get goalLean => '体重を落として引き締める';

  @override
  String get goalMass => '筋肉量を増やす';

  @override
  String get aboutYou => 'この道のりは、あなた自身のものです...';

  @override
  String get qThinkAbout => '体を鍛えることを\nどのくらい考えますか？';

  @override
  String get freqNever => 'まったく';

  @override
  String get freqSometimes => 'ときどき';

  @override
  String get freqOften => 'よく';

  @override
  String get freqAllTime => 'いつも';

  @override
  String get qEnergy => 'トレーニング中の\n調子はどうですか？';

  @override
  String get energyLow => '低め。一日中だるさが残る';

  @override
  String get energyDrops => 'セッションの途中でパフォーマンスが落ちる';

  @override
  String get energyHard => '最後のセットを押し切るのがつらい';

  @override
  String get energyHigh => '最初から最後まで高く安定している';

  @override
  String get stProgress => 'トレーニングしていても、伸びを実感しにくいことがある';

  @override
  String get stEffortTitle => '誰も見ていない努力は\n続かない';

  @override
  String get stEffortBody => '力を示す相手がいないと、伸びは遅く感じられ、努力は無意味に思えてきます';

  @override
  String get stAloneTitle => 'ひとりのトレーニングは\n退屈だ';

  @override
  String get stAloneBody => '誰も見ていない。誰も数えていない。1レップ、いやセットごと飛ばすのは簡単です';

  @override
  String get qName => 'なんとお呼びすれば\nよいですか？';

  @override
  String get nameHint => '3文字以上。対戦相手に表示される名前です。';

  @override
  String get basicInfo => 'では、基本的な情報を\nいくつか教えてください';

  @override
  String get qAge => '年齢を教えてください';

  @override
  String get qWeight => '現在の体重は\nどのくらいですか？';

  @override
  String get weightWhy => 'ランクの算出に体重が必要です。';

  @override
  String get privateNote => '入力内容は非公開で、誰にも共有されません。';

  @override
  String get qHeight => '身長を教えてください';

  @override
  String get qRelate => '下の文にあてはまりますか？';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get grindTitle => 'ライバルがいると\n手応えが変わる';

  @override
  String get grindBody => 'マッチのたびに実在の相手と向き合います。やるべきことをやって、どちらが鍛えたかを示しましょう。';

  @override
  String get allSet => '準備完了です！';

  @override
  String welcomeLifter(String name) {
    return 'ようこそ、$name さん。最初のライバルを見つけましょう。';
  }

  @override
  String get lifter => 'リフター';

  @override
  String get enterApp => 'OUTREPD をはじめる';

  @override
  String get commitTitle => 'では、あなた自身の道のりに\n約束をしましょう';

  @override
  String get holdLogo => 'ロゴを長押しして、準備ができたことを確認してください';

  @override
  String get expNone => 'トレーニングをしたことがない';

  @override
  String get iAm => 'わたしは……';

  @override
  String get finishMatchQ => 'マッチを終了しますか？';

  @override
  String get finishMatchBody => '総挙上量が確定し、相手と比較されます。';

  @override
  String get keepGoing => '続ける';

  @override
  String get forfeitQ => 'マッチを棄権しますか？';

  @override
  String get forfeitBody => 'いま抜けると LP を失います。';

  @override
  String get stay => '残る';

  @override
  String get forfeit => '棄権';

  @override
  String get pickExercises => '取り組む種目を選んでください';

  @override
  String matchingWith(String muscle) {
    return '同じランクの相手を探しています · $muscle';
  }

  @override
  String get getReady => '準備';

  @override
  String get timeLeft => '残り時間';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit の総挙上量';
  }

  @override
  String get finishMatch => 'マッチを終了';

  @override
  String get kgHint => 'KG';

  @override
  String get repsHint => 'レップ';

  @override
  String get addSet => 'セットを追加';

  @override
  String get matchComplete => 'マッチ終了';

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
  String get achRivalry => 'ライバル関係';

  @override
  String get achRivalryHint => '同じ相手に3回勝つ';

  @override
  String get nWonTitle => '勝ちました！';

  @override
  String nWonBody(String name, String muscle) {
    return '$muscle の日に $name に勝ちました';
  }

  @override
  String get nFriendTitle => '新しいフレンド申請';

  @override
  String nFriendBody(String name) {
    return '$name がつながりを希望しています';
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
  String get nameTooShortInline => '3文字以上の名前を入力してください';

  @override
  String get whyName => '対戦相手はすべての結果の横でこの名前を見ます';

  @override
  String get whyExperience => '同じ実力の相手とマッチングします';

  @override
  String get whyGoal => '最初におすすめする種目はここから決まります';

  @override
  String get whyAge => '年齢は、比較される筋力基準に影響します';

  @override
  String get whyWeight => 'ランクは体重に対する挙上重量で比べます。生の数値ではありません';

  @override
  String get whyHeight => '体重と合わせて、公平な基準を決めるのに使います';

  @override
  String get whyHabits => 'リマインダーと週の目標の提案がこれで決まります';

  @override
  String get transitionPartOfIt => '……だからこそ、本当にその一員になりましょう。';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get usernamePlaceholder => '名前';

  @override
  String get stRoutine => 'どの部位を本当に鍛えるべきか分からないので、たいてい同じメニューを繰り返しています';

  @override
  String get shortIn => 'in';

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
  String membersCount(String n) {
    return 'メンバー $n 人';
  }

  @override
  String eachCount(String n) {
    return '1人あたり $n';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }
}
