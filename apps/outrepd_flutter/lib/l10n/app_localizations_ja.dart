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
  String yourFriends(int count) {
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
  String xOfY(int a, int b) {
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
}
