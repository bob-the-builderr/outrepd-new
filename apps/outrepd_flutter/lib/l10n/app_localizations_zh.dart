// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class LZh extends L {
  LZh([String locale = 'zh']) : super(locale);

  @override
  String get tabFriends => '好友';

  @override
  String get tabRanks => '段位';

  @override
  String get tabMatch => '对战';

  @override
  String get tabProfile => '我的';

  @override
  String get challengeFriend => '向好友挑战';

  @override
  String get matchHistory => '对战记录';

  @override
  String get allMatches => '全部对战';

  @override
  String get wins => '胜';

  @override
  String get losses => '负';

  @override
  String get winRate => '胜率';

  @override
  String get streak => '连续';

  @override
  String get settings => '设置';

  @override
  String get accountSection => '账户';

  @override
  String get duelSection => '对决';

  @override
  String get hapticsEachRep => '每次计数时震动';

  @override
  String get showSkeleton => '显示骨架';

  @override
  String get showSkeletonHint => '用来确认摄像头看得见你';

  @override
  String get manageNotifications => '管理通知';

  @override
  String switchesOn(String on, String all) {
    return '$all 项中已开启 $on 项';
  }

  @override
  String get whoCanChallenge => '谁可以挑战我';

  @override
  String get blockedAccounts => '已屏蔽的账号';

  @override
  String get reportProblem => '举报问题';

  @override
  String get onDeviceNote => '姿态识别在这部手机上运行。视频和姿态数据都不会上传。';

  @override
  String get visibilitySection => '可见性';

  @override
  String get showMyCountry => '显示我的国家';

  @override
  String get showMyCountryHint => '关闭后将不在国家榜单中';

  @override
  String get safetySection => '安全';

  @override
  String get socialSection => '社交';

  @override
  String get noticeRaced => '有人挑战了我的组';

  @override
  String get noticeRacedHint => '得知发生过对决的唯一方式';

  @override
  String get noticeFriendOk => '我发出的请求被接受';

  @override
  String get noticesStoredNote => '关闭意味着根本不会保存，而不是保存后隐藏。';

  @override
  String get notSaved => '未保存';

  @override
  String get blockedIntro => '被屏蔽的账号无法挑战你、找到你或向你发送请求，且不会收到通知。';

  @override
  String blockedWhen(String when) {
    return '$when屏蔽';
  }

  @override
  String get unblock => '解除屏蔽';

  @override
  String get noBlockedTitle => '没有屏蔽任何人';

  @override
  String get noBlockedBody => '你可以在对方主页或举报页面屏蔽他们。';

  @override
  String get whatHappened => '发生了什么';

  @override
  String get reasonCheating => '作弊或虚假计数';

  @override
  String get reasonHarassment => '骚扰或辱骂';

  @override
  String get reasonContent => '不当内容';

  @override
  String get reasonImpersonation => '冒充他人';

  @override
  String get reasonOther => '其他';

  @override
  String get addDetails => '补充说明（可选）';

  @override
  String get alsoBlock => '同时屏蔽该账号';

  @override
  String get sendReport => '发送举报';

  @override
  String get reportSent => '举报已发送';

  @override
  String get reportingThisAccount => '正在举报该账号';

  @override
  String get exportIntro => '我们会把服务器保存的你的全部数据打包成文件发到邮箱，通常一分钟左右。';

  @override
  String get whatsIncluded => '包含内容';

  @override
  String get incProfile => '个人资料与段位';

  @override
  String get incSets => '每一组和每次计数';

  @override
  String get incDuels => '对决记录与 LP 变化';

  @override
  String get incFriends => '好友与被屏蔽的账号';

  @override
  String get incNotices => '你收到的通知';

  @override
  String get noLandmarksNote => '姿态关键点不在其中，也从未存在。摄像头在你手机上读取它们，不会发送到任何地方。';

  @override
  String get sendItTo => '发送至';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get createAccountTitle => '创建账户';

  @override
  String get createAccountBody => '登录后，这个账户就不会只存在于一部手机上。';

  @override
  String get createAccountAction => '创建账户';

  @override
  String get emailTakenSwitchToSignIn => '该邮箱已注册账户——请直接登录。';

  @override
  String get emailSignUpInvalid => '请检查邮箱和密码——密码至少需要6位。';

  @override
  String get tooManyCodes => '发送的验证码太多——请等几分钟后再试。';

  @override
  String get sendCodeAction => '发送验证码';

  @override
  String get noAccountForEmail => '找不到使用该邮箱的账户。';

  @override
  String get authEntryTagline => '俯卧撑。对决。冲上排行榜。';

  @override
  String get signUpWithEmail => '使用邮箱注册';

  @override
  String get alreadyHaveAccountQuestion => '已经有账户了?';

  @override
  String get logInAction => '登录';

  @override
  String get createYourAccountTitle => '创建你的账户';

  @override
  String get createAccountSubtitle => '不到一分钟。';

  @override
  String get usernameLabel => '用户名';

  @override
  String get emailLabel => '电子邮箱';

  @override
  String get logInSubtitle => '登录以保留你的段位。';

  @override
  String get checkYourEmailTitle => '查看你的邮箱';

  @override
  String codeSentTo(String email) {
    return '我们已向 $email 发送了6位验证码。';
  }

  @override
  String get didntGetIt => '没收到?';

  @override
  String resendInSeconds(String time) {
    return '$time 后重新发送';
  }

  @override
  String get wrongEmailGoBack => '邮箱错了?返回';

  @override
  String get usernameTaken => '该用户名已被占用。';

  @override
  String get wrongCode => '验证码错误或已过期。';

  @override
  String get resendCode => '重新发送验证码';

  @override
  String get codeResent => '已发送新验证码。';

  @override
  String signedInAs(String email) {
    return '已使用 $email 登录';
  }

  @override
  String get addressNotKept => '该地址只使用一次且不会保存——此账号本就没有邮箱。';

  @override
  String get requestMyData => '把我的数据发给我';

  @override
  String exportSent(String address) {
    return '已发送至 $address';
  }

  @override
  String get deleteIntro => '这将永久删除所有内容，无法撤销也无法恢复。';

  @override
  String get rankLabel => '段位';

  @override
  String get wantCopyFirst => '要先留一份副本吗？';

  @override
  String get wantCopyBody => '删除前先下载你的数据，之后就没有了。';

  @override
  String typeToConfirm(String word) {
    return '输入 $word 以确认';
  }

  @override
  String get deleteWord => '删除';

  @override
  String get deletePermanently => '永久删除';

  @override
  String get keepMyAccount => '保留我的账号';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get skip => '跳过';

  @override
  String get yourPicture => '你的头像';

  @override
  String get yourPictureHint => '头像框由段位决定，晋级后会随之变化。';

  @override
  String get couldNotUsePicture => '无法使用那张照片';

  @override
  String get couldNotSyncAvatar => '照片已保存,但还没有同步';

  @override
  String get couldNotShareCard => '无法分享这张卡片';

  @override
  String get couldNotOpenLink => '无法打开该链接';

  @override
  String get couldNotCheckUsername => '无法检查该名称——请重试';

  @override
  String get changeUsername => '更改用户名';

  @override
  String get usernameInvalidLength => '必须为4到20个字符，仅限字母、数字和 _';

  @override
  String get usernameChanged => '用户名已更改';

  @override
  String get usernameAlreadyChangedBody => '用户名每 14 天可更改一次。';

  @override
  String get gallery => '相册';

  @override
  String get camera => '拍照';

  @override
  String get awards => '成就';

  @override
  String get yourTitles => '你的称号';

  @override
  String get stillToEarn => '尚未解锁';

  @override
  String get noTitlesYet => '还没有。第一个只需要打一场。';

  @override
  String get wearHint => '点一下即可佩戴。别人看到你的地方，它都会出现在名字旁边。';

  @override
  String get worn => '佩戴中';

  @override
  String get titleUnlocked => '解锁称号';

  @override
  String get wearIt => '戴上';

  @override
  String get wearItLater => '以后再说';

  @override
  String get dayStreak => '天连续';

  @override
  String get bestEver => '历史最佳';

  @override
  String get restDaysLeft => '剩余休息日';

  @override
  String get restIsTraining => '休息也是训练的一部分。每周休两天不会中断你的连续记录。';

  @override
  String get global => '全球';

  @override
  String get topPlayers => '顶尖玩家';

  @override
  String get yourTier => '你的段位';

  @override
  String get challenge => '挑战';

  @override
  String get notifications => '通知';

  @override
  String get start => '开始';

  @override
  String get finish => '结束';

  @override
  String get reps => '次';

  @override
  String get howManyReally => '你实际做了多少个？';

  @override
  String get howManyReallyHint => '请填写你自己的计数，而不是应用的计数。之后将以此衡量计数器的准确度。';

  @override
  String get appearance => '外观';

  @override
  String get theme => '主题';

  @override
  String get language => '语言';

  @override
  String get privacy => '隐私';

  @override
  String get data => '数据';

  @override
  String get about => '关于';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get accept => '接受';

  @override
  String get visEveryone => '所有人';

  @override
  String get visFriends => '仅好友';

  @override
  String get visNobody => '任何人都不可';

  @override
  String get friendRequestsLabel => '好友申请';

  @override
  String get showOnLeaderboards => '在排行榜上展示我';

  @override
  String get exportData => '导出我的数据';

  @override
  String get version => '版本';

  @override
  String get rateApp => '给 OUTREPD 评分';

  @override
  String get contactSupport => '联系客服';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get openSourceLicences => '开源许可';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get needsServer => '无法连接。请检查网络后重试。';

  @override
  String get roomFriendly => '房间对战是友谊赛，不影响你的段位。';

  @override
  String get shareThisCode => '分享这个码';

  @override
  String get codeCopied => '已复制邀请码';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => '黑铁';

  @override
  String get tierBronze => '青铜';

  @override
  String get tierSilver => '白银';

  @override
  String get tierGold => '黄金';

  @override
  String get tierPlatinum => '铂金';

  @override
  String get tierDiamond => '钻石';

  @override
  String get tierMaster => '大师';

  @override
  String winLoss(String w, String l) {
    return '$w胜 $l负';
  }

  @override
  String get continueLabel => '继续';

  @override
  String get ttl_first_blood => '首胜之血';

  @override
  String get tdesc_first_blood => '完成你的第一场对战';

  @override
  String get ttl_found_footing => '站稳脚跟';

  @override
  String get tdesc_found_footing => '完成五场对战';

  @override
  String get ttl_regular => '常客';

  @override
  String get tdesc_regular => '二十场对战';

  @override
  String get ttl_fifty => '五十场';

  @override
  String get tdesc_fifty => '五十场对战';

  @override
  String get ttl_century => '百场';

  @override
  String get tdesc_century => '一百场对战';

  @override
  String get ttl_veteran => '老将';

  @override
  String get tdesc_veteran => '二百五十场对战';

  @override
  String get ttl_thousand_matches => '元老';

  @override
  String get tdesc_thousand_matches => '一千场对战';

  @override
  String get ttl_first_win => '胜者';

  @override
  String get tdesc_first_win => '赢下一场对战';

  @override
  String get ttl_on_a_roll => '势头正盛';

  @override
  String get tdesc_on_a_roll => '连胜三场';

  @override
  String get ttl_five_straight => '五连胜';

  @override
  String get tdesc_five_straight => '连胜五场';

  @override
  String get ttl_unstoppable => '势不可挡';

  @override
  String get tdesc_unstoppable => '连胜十场';

  @override
  String get ttl_untouchable => '无人能碰';

  @override
  String get tdesc_untouchable => '连胜二十场';

  @override
  String get ttl_giant_slayer => '巨人杀手';

  @override
  String get tdesc_giant_slayer => '击败高你两个段位的对手';

  @override
  String get ttl_comeback => '逆风翻盘';

  @override
  String get tdesc_comeback => '三连败后立刻拿下一胜';

  @override
  String get ttl_nemesis => '宿敌';

  @override
  String get tdesc_nemesis => '击败同一名对手五次';

  @override
  String get ttl_hundred_reps => '开了个头';

  @override
  String get tdesc_hundred_reps => '累计一百次有效计数';

  @override
  String get ttl_five_hundred => '热身完毕';

  @override
  String get tdesc_five_hundred => '累计五百次有效计数';

  @override
  String get ttl_the_machine => '机器';

  @override
  String get tdesc_the_machine => '累计一千次有效计数';

  @override
  String get ttl_five_thousand => '永不停歇';

  @override
  String get tdesc_five_thousand => '累计五千次有效计数';

  @override
  String get ttl_ten_thousand => '一万次';

  @override
  String get tdesc_ten_thousand => '累计一万次有效计数';

  @override
  String get ttl_fifty_thousand => '数不过来';

  @override
  String get tdesc_fifty_thousand => '累计五万次有效计数';

  @override
  String get ttl_first_tonne => '一吨';

  @override
  String get tdesc_first_tonne => '累计举起一千公斤';

  @override
  String get ttl_ten_tonnes => '十吨';

  @override
  String get tdesc_ten_tonnes => '累计举起一万公斤';

  @override
  String get ttl_six_figures => '六位数';

  @override
  String get tdesc_six_figures => '累计举起十万公斤';

  @override
  String get ttl_half_million => '五十万';

  @override
  String get tdesc_half_million => '累计举起五十万公斤';

  @override
  String get ttl_million_kg => '百万公斤俱乐部';

  @override
  String get tdesc_million_kg => '累计举起一百万公斤';

  @override
  String get ttl_two_days => '又回来了';

  @override
  String get tdesc_two_days => '连续两天训练';

  @override
  String get ttl_no_days_off => '全勤';

  @override
  String get tdesc_no_days_off => '连续七天训练';

  @override
  String get ttl_fortnight => '两周';

  @override
  String get tdesc_fortnight => '十四天连续记录';

  @override
  String get ttl_unbroken => '从未中断';

  @override
  String get tdesc_unbroken => '三十天连续记录';

  @override
  String get ttl_sixty_days => '习惯';

  @override
  String get tdesc_sixty_days => '六十天连续记录';

  @override
  String get ttl_hundred_days => '一百天';

  @override
  String get tdesc_hundred_days => '一百天连续记录';

  @override
  String get ttl_year_round => '全年无休';

  @override
  String get tdesc_year_round => '三百六十五天连续记录';

  @override
  String get ttl_perfect_week => '完美一周';

  @override
  String get tdesc_perfect_week => '一周内每天训练';

  @override
  String get ttl_perfect_month => '完美一月';

  @override
  String get tdesc_perfect_month => '四个完美的一周';

  @override
  String get ttl_bronze_tier => '走出黑铁';

  @override
  String get tdesc_bronze_tier => '达到青铜';

  @override
  String get ttl_silver_tier => '银色';

  @override
  String get tdesc_silver_tier => '达到白银';

  @override
  String get ttl_golden_era => '黄金时代';

  @override
  String get tdesc_golden_era => '达到黄金';

  @override
  String get ttl_platinum_tier => '铂金';

  @override
  String get tdesc_platinum_tier => '达到铂金';

  @override
  String get ttl_diamond_tier => '钻石之手';

  @override
  String get tdesc_diamond_tier => '达到钻石';

  @override
  String get ttl_master_tier => '大师';

  @override
  String get tdesc_master_tier => '达到大师';

  @override
  String get ttl_clean_hands => '干净利落';

  @override
  String get tdesc_clean_hands => '整组动作每一次都被计入';

  @override
  String get ttl_spotless => '毫无瑕疵';

  @override
  String get tdesc_spotless => '十组干净的训练';

  @override
  String get ttl_textbook => '教科书级';

  @override
  String get tdesc_textbook => '五十组干净的训练';

  @override
  String get ttl_all_rounder => '全能选手';

  @override
  String get tdesc_all_rounder => '累计五个不同动作';

  @override
  String get ttl_explorer => '探索者';

  @override
  String get tdesc_explorer => '累计十五个不同动作';

  @override
  String get ttl_encyclopedia => '百科全书';

  @override
  String get tdesc_encyclopedia => '累计四十个不同动作';

  @override
  String get ttl_early_bird => '早班';

  @override
  String get tdesc_early_bird => '早上七点前完成十次训练';

  @override
  String get ttl_sunrise_club => '日出俱乐部';

  @override
  String get tdesc_sunrise_club => '早上七点前完成五十次训练';

  @override
  String get ttl_night_owl => '夜班';

  @override
  String get tdesc_night_owl => '晚上十点后完成十次训练';

  @override
  String get ttl_graveyard => '通宵班';

  @override
  String get tdesc_graveyard => '晚上十点后完成五十次训练';

  @override
  String get ttl_not_alone => '不再独行';

  @override
  String get tdesc_not_alone => '添加第一位好友';

  @override
  String get ttl_well_connected => '人脉广阔';

  @override
  String get tdesc_well_connected => '十位好友';

  @override
  String get ttl_the_gym_knows => '整个健身房都认识你';

  @override
  String get tdesc_the_gym_knows => '五十位好友';

  @override
  String get forfeitQ => '认输退出？';

  @override
  String get forfeitBody => '现在离开会扣除 LP。';

  @override
  String get forfeit => '认输';

  @override
  String get getReady => '准备';

  @override
  String get you => '你';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => '返回首页';

  @override
  String get mgChest => '胸';

  @override
  String get nWonTitle => '你赢了！';

  @override
  String nWonBody(String name, String muscle) {
    return '你在$muscle日击败了 $name';
  }

  @override
  String get nFriendTitle => '新的好友申请';

  @override
  String get nRacedTitle => '有人挑战了你的组';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name 挑战了你的组但没追上，$yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name 挑战了你的组并赢了，$theirs–$yours';
  }

  @override
  String get nFriendOkTitle => '好友请求已接受';

  @override
  String nFriendOkBody(String name) {
    return '$name 接受了你的请求';
  }

  @override
  String nFriendBody(String name) {
    return '$name 想加你为好友';
  }

  @override
  String get nChallengedTitle => '再来一局';

  @override
  String nChallengedBody(String name) {
    return '$name 想再来一局';
  }

  @override
  String get challengeSentTitle => '挑战已发送';

  @override
  String challengeSentBody(String name) {
    return '我们会通知$name。等对方完成后再回来看看。';
  }

  @override
  String get challengeNotSentTitle => '发送失败';

  @override
  String get challengeNotSentBody => '请检查网络连接，然后在比赛页重试。';

  @override
  String get challengeGoneTitle => '挑战已失效';

  @override
  String get challengeGoneBody => '已经进行过，或已被撤回。';

  @override
  String repsRecordedLine(String reps) {
    return '已记录 $reps 次';
  }

  @override
  String get nAchTitle => '解锁成就';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => '段位提升！';

  @override
  String nRankBody(String rank) {
    return '你已达到 $rank';
  }

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String daysAgo(String n) {
    return '$n 天前';
  }

  @override
  String weeksAgo(String n) {
    return '${n} 周前';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get lpUnit => 'LP';

  @override
  String get trueCountHint => '例如 12';

  @override
  String get couldNotSaveSession => '无法保存本次训练';

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String get noFriendsTitle => '还没有好友';

  @override
  String get noFriendsBody => '和认识的人对决，感觉完全不一样。';

  @override
  String get decline => '拒绝';

  @override
  String requestSent(String name) {
    return '已向 $name 发送请求';
  }

  @override
  String nowFriends(String name) {
    return '你和 $name 现在是好友了';
  }

  @override
  String get noOneFound => '没有人叫这个名字';

  @override
  String get noMatchesTitle => '还没有对战';

  @override
  String get noMatchesBody => '第一场会出现在这里，无论输赢。';

  @override
  String get noNotificationsTitle => '暂无新消息';

  @override
  String get noNotificationsBody => '对战邀请、结果和好友申请都会送到这里。';

  @override
  String get countedThat => '本轮计数';

  @override
  String get thatIsRight => '没错';

  @override
  String get useMyCount => '用我的计数';

  @override
  String get confirmHint => '如果摄像头数错了，请修改。';

  @override
  String get unsureMovement => '不确定这是不是正确的动作，请核对数字。';

  @override
  String get noRanksYet => '暂无排名';

  @override
  String get noRanksYetBody => '打一场对决，榜单就会出现。';

  @override
  String get ranksTitle => '段位';

  @override
  String get totalReps => '总次数';

  @override
  String get recent => '最近';

  @override
  String wonVs(String name) {
    return '战胜 ${name}';
  }

  @override
  String lostVs(String name) {
    return '负于 ${name}';
  }

  @override
  String hoursAgo(String n) {
    return '${n} 小时前';
  }

  @override
  String toNextTier(String n, String tier) {
    return '距 ${tier} 还差 ${n}';
  }

  @override
  String get noMatchesYet => '还没有对决';

  @override
  String get noMatchesYetBody => '你的第一场对决会显示在这里，无论输赢。';

  @override
  String get searchByUsername => '按用户名搜索';

  @override
  String get incomingRequests => '收到的请求';

  @override
  String get noRequestsWaiting => '目前没有待处理的请求';

  @override
  String get addFriendAction => '添加好友';

  @override
  String get addFriendHint => '输入对方的用户名，或其个人资料上的 # 代码。';

  @override
  String get usernameOrCode => '用户名或 # 代码';

  @override
  String get sendRequest => '发送请求';

  @override
  String onlineNowCount(String count) {
    return '在线 · $count';
  }

  @override
  String offlineCount(String count) {
    return '离线 · $count';
  }

  @override
  String get invite => '邀请';

  @override
  String get headToHeadTitle => '交手记录';

  @override
  String get vsYouCaption => '对你';

  @override
  String get h2hYou => '你';

  @override
  String get h2hThem => '他';

  @override
  String headToHead(String wins, String losses) {
    return '对你 $wins胜 $losses负';
  }

  @override
  String get neverPlayedYou => '还没和你打过';

  @override
  String noHistoryWithThem(String username) {
    return '你还没和$username交过手。';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return '上次：$yourReps–$theirReps，$when。';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return '你对他的最佳成绩是$reps。';
  }

  @override
  String get viewFullProfile => '查看完整资料';

  @override
  String get moreOptions => '更多选项';

  @override
  String get block => '屏蔽';

  @override
  String get blockRowBody => '对方将无法挑战你或查看你的资料';

  @override
  String get report => '举报';

  @override
  String get reportRowBody => '将在24小时内处理';

  @override
  String muteChallenges(String username) {
    return '屏蔽来自$username的挑战';
  }

  @override
  String blockedLifter(String username) {
    return '已屏蔽$username';
  }

  @override
  String mutedLifter(String username) {
    return '已静音$username';
  }

  @override
  String get addFriendButton => '添加好友';

  @override
  String get alreadyFriends => '好友';

  @override
  String get couldNotLoadProfile => '无法加载此资料';

  @override
  String get noFriendsMatch => '没有这个名字的人';

  @override
  String get yourClimb => '你的攀登';

  @override
  String floorKept(String tier, String rank) {
    return '$tier 已经是你的了，不会再掉到 $rank 以下。';
  }

  @override
  String dayStreakCount(String count) {
    return '连续 $count 天';
  }

  @override
  String get findMatch => '寻找对手';

  @override
  String rankedTerms(String seconds) {
    return '$seconds 秒 · 排位赛';
  }

  @override
  String get practiceTerms => '练习 — 不计排位，没有对手';

  @override
  String get practiceComplete => '练习结束';

  @override
  String get noRankYet => '还没有段位';

  @override
  String get unranked => '未定级';

  @override
  String get practiceFirst => '先练一下';

  @override
  String get noConnection => '没有网络';

  @override
  String get practiceOffline => '离线练习';

  @override
  String get retry => '重试';

  @override
  String get youWonPlain => '你赢了';

  @override
  String get cameraNeededTitle => '需要相机权限';

  @override
  String get cameraNeededBody => 'outrepd 通过观察你的身体动作来计数。识别在你的设备上进行，不会上传任何内容。';

  @override
  String get openSettings => '打开设置';

  @override
  String get allowCamera => '允许相机';

  @override
  String get notNow => '暂不';

  @override
  String get noCameraTitle => '没有找到相机';

  @override
  String get noCameraBody => '计数靠相机完成，所以这台设备无法给对决计分。其余功能正常。';

  @override
  String get noConnectionBody => '对决需要网络。冒险离线也能玩，计数会稍后同步。';

  @override
  String get getBackInFrame => '回到画面里';

  @override
  String get clockStillRunning => '计时还在走，但没有计数。';

  @override
  String get giveUp => '放弃';

  @override
  String get lpMovesWithGap => '积分根据次数差变化——领先越多，获得越多';

  @override
  String get searchingForOpponent => '正在寻找对手';

  @override
  String get getIntoPosition => '准备姿势';

  @override
  String get framingHint => '手腕和脚踝要在画面内';

  @override
  String get goUp => '上推';

  @override
  String get goDown => '下降';

  @override
  String get bestSet => '最佳一组';

  @override
  String get record => '战绩';

  @override
  String get last7Days => '最近 7 天';

  @override
  String repsCount(String count) {
    return '$count 个';
  }

  @override
  String get viewAll => '查看全部';

  @override
  String get shareProfile => '分享个人资料';

  @override
  String get share => '分享';

  @override
  String get duelMeOnOutrepd => '在outrepd上挑战我';

  @override
  String get shareStory => '故事';

  @override
  String get sharePost => '帖子';

  @override
  String get copyLink => '复制';

  @override
  String get linkCopied => '链接已复制';

  @override
  String get currentRankLabel => '当前段位';

  @override
  String get winInitial => '胜';

  @override
  String get lossInitial => '负';

  @override
  String get dayInitial => '天';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline => '俯卧撑对决。手机替你数。对面也有人在数。';

  @override
  String get obGetStarted => '开始';

  @override
  String get obHaveAccount => '我已经有账号';

  @override
  String get obTwoThings => '两件小事。';

  @override
  String get obAgeQuestion => '你多大了？';

  @override
  String get obHealthConsent => '我明白 outrepd 只负责计数，不提供医疗或训练建议。哪里疼了我就停下。';

  @override
  String get obTermsIntro => '继续即表示你同意';

  @override
  String get obTerms => '条款';

  @override
  String get obAnd => '和';

  @override
  String get obPrivacy => '隐私政策';

  @override
  String get obCameraTitle => 'outrepd 需要用摄像头';

  @override
  String get obCameraBody => '它看着你的身体动作来计数。没有别的办法。';

  @override
  String get obCameraPrivateTitle => '没有任何东西离开你的手机';

  @override
  String get obCameraPrivateBody => '身体识别在这台设备上完成。视频不会被保存或上传。';

  @override
  String get obWhyNeeded => '为什么需要这个？';

  @override
  String get obPlacementTitle => '把手机放在地上';

  @override
  String get obPlacementBody => '靠墙放，大约在你前方一米。';

  @override
  String get obCheckHandsFeet => '头、肩和双手都在画面里';

  @override
  String get obCheckFacing => '正对手机，不要侧身';

  @override
  String get obCheckLight => '房间灯打开';

  @override
  String get obImSetUp => '我准备好了';

  @override
  String get obFramingTitle => '摆好俯卧撑姿势';

  @override
  String get obFramingShoulders => '肩和胯';

  @override
  String get obFramingWrists => '手腕';

  @override
  String get obLooksGood => '看起来不错';

  @override
  String get obCalibrating => '校准中';

  @override
  String get obOneMoreRep => '再做一个，好记住你的幅度';

  @override
  String get obCalibrationHint => '用你平时的深度做三个俯卧撑';

  @override
  String get obCalibrated => '校准完成。';

  @override
  String get obCalibratedBody => 'outrepd 已经知道你的幅度了。深度是按你来量的，不是按一个固定数字。';

  @override
  String get obRepsCounted => '已计次数';

  @override
  String get obAverageDepth => '平均深度';

  @override
  String get obForm => '动作';

  @override
  String get obFormClean => '干净';

  @override
  String get obAvailable => '可以用';

  @override
  String get obTaken => '已被占用';

  @override
  String get obGotIt => '知道了';

  @override
  String get obFormMixed => '不稳定';

  @override
  String get justNow => '刚刚';

  @override
  String get counterAccuracy => '计数准确度';

  @override
  String get counterAccuracyCaption => '摄像头数得有多准';

  @override
  String measuredOverSets(String count) {
    return '基于 $count 组测得';
  }

  @override
  String get accExact => '完全正确';

  @override
  String get accWithinOne => '误差 1 次以内';

  @override
  String get accAverageMiss => '平均误差';

  @override
  String get accTendsTo => '倾向';

  @override
  String get accCountsHigh => '数多';

  @override
  String get accCountsLow => '数少';

  @override
  String get accCountsEven => '不多不少';

  @override
  String get accWorstMiss => '最大误差';

  @override
  String get accNothingYet => '还没有测过';

  @override
  String get accNothingYetBody => '每次在练习组之后确认次数，这一组都会和你报的数字比对。结果会显示在这里。';

  @override
  String accNeedMore(String count) {
    return '还早。大约再来 $count 组，这个数字才有意义。';
  }

  @override
  String get accRecentSets => '最近的组';

  @override
  String get accCameraSaid => '摄像头';

  @override
  String get accYouSaid => '你';

  @override
  String get accHowItWorks => '这些来自你自己，就在这台手机上。不会发送到任何地方。';

  @override
  String levelNumber(String n) {
    return '等级 $n';
  }

  @override
  String get youLostPlain => '你输了';

  @override
  String get rematch => '再来一局';

  @override
  String get shareAction => '分享';

  @override
  String get doneAction => '完成';

  @override
  String get continueAction => '继续';

  @override
  String get promotedLabel => '晋级';

  @override
  String get highestReached => '你的历史最高';

  @override
  String repsOff(String n) {
    return '差 $n 次。';
  }

  @override
  String get closestYet => '目前最接近的一场。';

  @override
  String repsAhead(String n) {
    return '领先 $n 次。';
  }

  @override
  String get winnerLabel => '胜者';

  @override
  String get newPersonalBest => '个人新纪录';

  @override
  String get cantReachServer => '无法连接服务器。请检查网络后重试。';

  @override
  String pushUpsInSeconds(String seconds) {
    return '$seconds秒俯卧撑';
  }

  @override
  String beatOpponent(String name, String score) {
    return '击败 $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return '输给 $name $score';
  }

  @override
  String get thinkYouCanBeatMe => '你觉得你能赢我吗？';

  @override
  String get usernameNotAllowed => '这个名字不能使用，请换一个。';

  @override
  String get yourBest => '你的最佳';

  @override
  String get theClock => '计时';

  @override
  String get nobodyFreeRaceBest => '现在没有段位相近的对手。挑战你自己的最佳成绩吧。这一局不影响段位。';

  @override
  String get nobodyFreeFirstScore => '现在没有段位相近的对手。先创下你的第一个成绩吧。这一局不影响段位。';

  @override
  String bestStillIs(String count) {
    return '你的最佳仍是 $count';
  }

  @override
  String get setInPoolTitle => '你的成绩已进入匹配池';

  @override
  String get setInPoolBody => '下一位段位相近的玩家会挑战这组成绩。谁赢了会在通知里显示，届时你的段位才会变动。';

  @override
  String get obWhyNeededBody =>
      '每一次都按你下得多低、起得多高来判定，而这只有摄像头能看到。没有它就没法计数，没有计数就没有对决。摄像头只在做组时开启。';

  @override
  String get obWelcomeBack => '欢迎回来';

  @override
  String obTitlesHeading(String count) {
    return '$count 个称号等你获得';
  }

  @override
  String get obTitlesBody => '赢得胜利、连胜、标准动作、早起训练等都能获得。可以选一个显示在你的名字下方。';

  @override
  String get obFriendsHeading => '和朋友一决高下';

  @override
  String get obFriendsBody => '朋友可以用这个代码添加你。随时向他们发起挑战，你们之间的战绩会一直保留。';

  @override
  String get obLetsGo => '出发';

  @override
  String get paywallTitle => '从黑铁一路登上大师';

  @override
  String get paywallPerkDuels => '由摄像头裁判的对决';

  @override
  String get paywallPerkLadder => '实时排位';

  @override
  String get paywallPerkFriends => '好友与挑战';

  @override
  String get paywallPerkHistory => '每场比赛的每一次';

  @override
  String get paywallYearly => '年度';

  @override
  String get paywallWeekly => '每周';

  @override
  String paywallPerWeek(String price) {
    return '${price}/周';
  }

  @override
  String get paywallEveryWeek => '每周';

  @override
  String paywallSave(String percent) {
    return '省 ${percent}%';
  }

  @override
  String get paywallStart => '去除广告';

  @override
  String get paywallRenewsPlay => '取消前自动续订。可随时在 Google Play 中取消。';

  @override
  String get paywallRenewsApple => '取消前自动续订。可随时在 Apple 账户设置中取消。';

  @override
  String get paywallRestore => '恢复购买';

  @override
  String get paywallTerms => '条款';

  @override
  String get paywallPrivacy => '隐私';

  @override
  String get paywallLoadFailed => '无法加载方案。请检查网络后重试。';

  @override
  String get paywallBuyFailed => '购买未完成。请重试。';

  @override
  String get paywallPending => '你的付款正在处理中。商店确认后即可解锁全部内容。';

  @override
  String get paywallNothingToRestore => '没有可恢复的订阅。';

  @override
  String get paywallRestored => '订阅已恢复';

  @override
  String paywallSignedInAs(String email) {
    return '已登录：${email}';
  }

  @override
  String get deleteKeepsSubscription => '删除账户不会取消订阅：扣费的是应用商店，不是 outrepd。请先在 Google Play 或 Apple 账户设置中取消。';

  @override
  String get signOut => '退出登录';

  @override
  String get signOutQuestion => '要退出登录吗？';

  @override
  String get signOutBody => '你的账户会保持原样，排位、记录和订阅都在。随时可以用同样的方式重新登录。';

  @override
  String get shareVictory => '胜利';

  @override
  String get shareRematch => '再战？';

  @override
  String friendCodeInvite(String code) {
    return '来 outrepd 和我对决吧。用我的好友码 ${code} 加我\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => '声音';

  @override
  String get soundsHint => '3、2、1 的提示音，每次计数的滴答声，以及回合结束音。可与音乐同时播放。';

  @override
  String get phoneSection => '此手机';

  @override
  String get allowNotifications => '允许通知';

  @override
  String get allowNotificationsHint => '手机设置中已关闭 OUTREPD 的通知，因此下面的通知都无法送达。';

  @override
  String get remindersSection => '提醒';

  @override
  String get dailyReminder => '每日提醒';

  @override
  String get dailyReminderHint => '只在当天目标还没完成时提醒。';

  @override
  String get reminderTime => '时间';

  @override
  String get reminderTitle => '该做今天的俯卧撑了';

  @override
  String reminderStreakBody(String count) {
    return '保持你 ${count} 天的连续记录。做一组就够了。';
  }

  @override
  String get channelMatches => '对战与好友';

  @override
  String get channelReminders => '每日提醒';

  @override
  String get liveTag => '实时';

  @override
  String get reconnecting => '重新连接中';

  @override
  String get rankedLive => '排位 · 实时';

  @override
  String get lookingForLive => '正在寻找实时对手';

  @override
  String ofTime(String time) {
    return '共 ${time}';
  }

  @override
  String liveFallbackAt(String time) {
    return '到 ${time} 时将改为挑战已保存的一组';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} 正在镜头前。同一计时，同时开始。';
  }

  @override
  String get nobodyLiveTitle => '现在没有人在线实时对战';

  @override
  String get nobodyLiveBody => '你将改为挑战已保存的一组';

  @override
  String didRepsIn(String reps) {
    return '60 秒内完成 ${reps} 个';
  }

  @override
  String get sameRankPoints => '与实时对战相同的排位分';

  @override
  String get raceIt => '开始挑战';

  @override
  String get onlineNow => '在线';

  @override
  String get friendlyNoRank => '友谊赛 · 不计排位';

  @override
  String waitingForName(String name) {
    return '正在等待 ${name}';
  }

  @override
  String get weSentThemANotice => '已向对方发送通知';

  @override
  String get untilInviteRunsOut => '邀请失效前';

  @override
  String get cancelInvite => '取消邀请';

  @override
  String inviteDeclined(String name) {
    return '${name} 表示现在不行';
  }

  @override
  String get inviteRanOut => '邀请已失效';

  @override
  String get inviteAgain => '再次邀请';

  @override
  String liveInviteFrom(String name) {
    return '${name} 正在等你实时对战';
  }

  @override
  String timeLeft(String time) {
    return '剩余 ${time}';
  }

  @override
  String get joinLive => '加入';

  @override
  String get nLiveTitle => '实时对战邀请';

  @override
  String nLiveBody(String name) {
    return '${name} 想和你实时对战';
  }

  @override
  String get inviteGone => '该邀请已失效';

  @override
  String opponentDropped(String name) {
    return '${name} 的连接断开了。继续：本回合按时间结束。';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} 已放弃。完成本回合即可获胜。';
  }

  @override
  String get calledOffTitle => '对战已取消';

  @override
  String calledOffBody(String name) {
    return '${name} 未能及时就位。没有记录任何结果。';
  }

  @override
  String waitingForFinal(String name) {
    return '正在等待 ${name} 的最终计数…';
  }

  @override
  String get wantsToBeFriends => '想和你成为好友';

  @override
  String get giveUpQuestion => '放弃本回合？';

  @override
  String get giveUpBody => '无论你现在做了多少个，都算作失败。';

  @override
  String waitingToJoin(String name) {
    return '正在等待 ${name} 加入';
  }

  @override
  String get removeFriend => '删除好友';

  @override
  String get removeFriendBody => '对方不会收到通知，你们之后还可以重新添加';

  @override
  String removeFriendQuestion(String username) {
    return '要将 ${username} 从好友中删除吗？';
  }

  @override
  String get removeAction => '删除';

  @override
  String removedFriend(String username) {
    return '已将 ${username} 从好友中删除';
  }

  @override
  String get noticeChallenged => '有人向我发起复赛挑战';

  @override
  String get noticeLiveInvite => '好友邀请我进行实时对战';

  @override
  String get trialToday => '今天';

  @override
  String get trialTodayBody => '所有对决，实时与排位，全部解锁。';

  @override
  String trialDay(String day) {
    return '第 ${day} 天';
  }

  @override
  String get trialReminderBody => '试用结束前一天我们会提醒你。';

  @override
  String get trialEndBody => '你的方案开始。在此之前取消则无需付费。';

  @override
  String trialTag(String days) {
    return '${days} 天免费';
  }

  @override
  String trialCta(String days) {
    return '开始我的 ${days} 天免费试用';
  }

  @override
  String trialThenYearly(String price) {
    return '现在无需付款 · 之后 ${price}/年';
  }

  @override
  String trialThenWeekly(String price) {
    return '现在无需付款 · 之后 ${price}/周';
  }

  @override
  String get trialEndsTitle => '你的免费试用明天结束';

  @override
  String get trialEndsBody => '继续攀登，或在此之前于订阅设置中取消。';

  @override
  String get obIdeaTitle => '60 秒，一个对手。';

  @override
  String get obIdeaRival => '真人对手，实时或其录下的一组';

  @override
  String get obIdeaCamera => '摄像头在你的手机上数每一次';

  @override
  String get thisMonth => '本月';

  @override
  String shortDays(String n) {
    return '${n}天';
  }

  @override
  String shortHours(String n) {
    return '${n}小时';
  }

  @override
  String get awardChampion => '冠军';

  @override
  String get awardPodium => '领奖台';

  @override
  String get awardTop10 => '前十';

  @override
  String get awardRegular => '20 俱乐部';

  @override
  String monthToTop10(String lp) {
    return '距前十还差 ${lp} LP';
  }

  @override
  String monthIfEndedNow(String award) {
    return '如果本月现在结束：${award}';
  }

  @override
  String get monthJoinHint => '打一场排位赛即可登上本月榜单';

  @override
  String monthRegularProgress(String progress) {
    return '20 俱乐部徽章 · 排位赛 ${progress}';
  }

  @override
  String get monthRegularEarned => '本月 20 俱乐部徽章已获得';

  @override
  String get monthEmptyTitle => '全新的一个月';

  @override
  String get monthEmptyBody => '本月还没有人赢得 LP。赢下第一场排位赛，你就领先。';

  @override
  String rankedDuelsCount(String n) {
    return '${n} 场排位赛';
  }

  @override
  String get monthlyAwards => '月度荣誉';

  @override
  String get seasonOver => '赛季结束';

  @override
  String get seasonOverBody => '已显示在你的主页上。新的一个月从零开始。';

  @override
  String get seasonPlayCta => '开始新的一个月';

  @override
  String get rematchLive => '实时再战';

  @override
  String rematchWaiting(String name) {
    return '等待 ${name}';
  }

  @override
  String rematchAsked(String name) {
    return '${name} 想再战';
  }

  @override
  String get rematchGone => '这次没有再战';

  @override
  String get twoRankedADay => '友谊赛 · 同一对手每天 2 场排位';

  @override
  String monthMove(String move) {
    return '本月 · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return '从 ${rank}';
  }

  @override
  String liveOnlineNow(String n) {
    return '${n} 人在线';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} 人在匹配';
  }

  @override
  String get dailyGoalTitle => '今日目标';

  @override
  String get dailyGoalDone => '今天已完成';

  @override
  String dailyGoalProgress(String progress) {
    return '俯卧撑 ${progress}';
  }

  @override
  String dailyGoalLeft(String n) {
    return '还差 ${n}';
  }

  @override
  String get dailyGoalChange => '更改';

  @override
  String get dailyGoalPick => '你的每日目标';

  @override
  String dailyGoalOption(String n) {
    return '每天 ${n} 个';
  }

  @override
  String widgetGoalOf(String goal) {
    return '今日目标 ${goal}';
  }

  @override
  String get saveToAppleHealth => '将训练保存到 Apple 健康';

  @override
  String get saveToHealthConnect => '将训练保存到 Health Connect';

  @override
  String get saveToHealthHint => '每一组都会记为一次力量训练。不会读取任何数据。';

  @override
  String get healthNotAllowed => '尚未允许。你可以在手机的健康设置中允许。';

  @override
  String reminderLeft(String count) {
    return '离今天的目标还差 ${count} 个俯卧撑。';
  }

  @override
  String get liveInviteHint => '在线的好友可以马上加入。其他好友会收到通知，有一分钟时间加入。';

  @override
  String get requestSentShort => '已发送请求';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPD 可与 ${health} 配合使用';
  }

  @override
  String healthCardBody(String health) {
    return '你完成的每一组都会作为力量训练保存到 ${health}。OUTREPD 从不读取你的健康数据。';
  }

  @override
  String savedToHealth(String health) {
    return '已保存到 ${health}';
  }

  @override
  String get usernameTooShort => '太短了：至少 4 个字符';

  @override
  String get usernameBadCharacters => '只能使用字母、数字和 _';

  @override
  String get usernameNeedsLetter => '至少包含一个字母或数字';

  @override
  String usernameChangeAgainOn(String date) {
    return '你可以在 ${date} 再次更改';
  }

  @override
  String get continueWithApple => '通过 Apple 继续';

  @override
  String get continueWithGoogle => '通过 Google 继续';

  @override
  String get socialSignInFailed => '无法登录，请重试。';

  @override
  String get chooseUsernameTitle => '选择你的用户名';

  @override
  String get chooseUsernameSubtitle => '其他人会通过它找到你，并在排行榜上看到你。';

  @override
  String get authHeroTitle => '超越任何人。';

  @override
  String get authHeroSubtitle => '实时俯卧撑对决，由你的摄像头计数。';

  @override
  String get createAccountPitch => '你的段位和对决，在任何手机上都在。';

  @override
  String get usernameSpacesHint => '空格会变成 _';

  @override
  String get emailCodeNote => '我们会给你发送 6 位数验证码邮件，无需密码。';

  @override
  String get continueWithEmail => '通过邮箱继续';

  @override
  String get thisSeason => '本赛季';

  @override
  String get thisWeek => '本周';

  @override
  String get weekStartsAgain => '每周一重新开始';

  @override
  String get lengthWeek => '周';

  @override
  String get lengthMonth => '月';

  @override
  String get weekJoinHint => '本周赢一场排位对决即可上榜';

  @override
  String get weekInTop3 => '本周前三';

  @override
  String weekToTop3(String n) {
    return '距前三还差 ${n} LP';
  }

  @override
  String get boardActiveNote => '过去 30 天内活跃的玩家';

  @override
  String get boardTieNote => '并列时胜场多者在前';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return '次数差 ${reps} · ${rank} 对手 ${adjust}';
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
    return '距等级 ${level} 还差 ${n} XP';
  }

  @override
  String xpHow(String rep, String match) {
    return '每次 ${rep} XP，每场对决 ${match}';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return '次数 ${n}';
  }

  @override
  String xpForMatch(String n) {
    return '对决 ${n}';
  }

  @override
  String get levelUp => '升级';

  @override
  String get levelUpBody => '每一次都算数。继续加油。';

  @override
  String giveUpAhead(String n) {
    return '你领先 ${n} 个';
  }

  @override
  String giveUpBehind(String n) {
    return '你落后 ${n} 个';
  }

  @override
  String get giveUpTied => '平手';

  @override
  String get keepGoing => '继续';

  @override
  String get stay => '留下';

  @override
  String lastN(String n) {
    return '最近 ${n} 场';
  }

  @override
  String get firstMatchForTier => '打完第一场比赛即可进入排名。所有人都从 Iron V 开始。';

  @override
  String get firstMatchForBoard => '打完第一场比赛即可登上排行榜。所有人都从 Iron V 开始。';

  @override
  String get playFirstMatch => '开始第一场比赛';

  @override
  String firstMatchTerms(String seconds) {
    return '1 场 · ${seconds} 秒';
  }

  @override
  String get placedLabel => '你已进入排名';

  @override
  String get placedBody => '所有人都从这里开始。只有赢才能往上爬。';

  @override
  String get placedHow => '赢下比赛获得 LP。击败段位更高的对手得到更多。';

  @override
  String get levelBesideName => '显示在你的名字旁，随处可见';

  @override
  String get weekRaceTitle => '本周竞赛';

  @override
  String get streakDoneToday => '今天已完成';

  @override
  String get streakTrainToday => '今天练一次，多加一天';

  @override
  String get raceChartTitle => '这一分钟的走势';

  @override
  String raceYouLead(String time) {
    return '${time} · 你取得领先';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} 取得领先';
  }

  @override
  String get bringFriendTitle => '叫上朋友';

  @override
  String get bringFriendBody => '发送你的链接。它会打开你的主页，对方可以在那里加你。';

  @override
  String get bringFriendShare => '分享我的链接';

  @override
  String get bringFriendShareText => '来 OUTREPD 和我比俯卧撑。60 秒，实时，摄像头计数。';

  @override
  String orFriendCode(String code) {
    return '或好友码 ${code}';
  }

  @override
  String get countryPickerTitle => '你的国家/地区';

  @override
  String get countrySearch => '搜索';

  @override
  String get countryFromPhone => '来自你的手机';

  @override
  String get countryAll => '所有国家/地区';

  @override
  String get countryChoose => '选择你的国家/地区';

  @override
  String get countryChange => '更改';

  @override
  String get countryForBoard => '用于你所在国家/地区的排行榜';

  @override
  String get countryLabel => '国家/地区';

  @override
  String get countryChanged => '国家/地区已更改';

  @override
  String get countryEvery14 => '和名字一样，每 14 天一次';

  @override
  String get countryNotSaved => '无法保存国家/地区，请重试。';

  @override
  String get adventure => '冒险';

  @override
  String stageNumber(String n) {
    return '第 ${n} 关';
  }

  @override
  String adventureLevelIn(String level, String world) {
    return '第 ${level} 关 · ${world}';
  }

  @override
  String adventureClearedOf(String cleared, String total) {
    return '已通过 ${cleared}/${total} · 不计排位';
  }

  @override
  String get worldIron => '黑铁矿坑';

  @override
  String get worldBronze => '青铜沙丘';

  @override
  String get worldSilver => '白银峰';

  @override
  String get worldGold => '黄金城堡';

  @override
  String get worldPlatinum => '铂金冰川';

  @override
  String get worldDiamond => '钻石洞窟';

  @override
  String get worldMaster => '大师王座';

  @override
  String worldNumber(String n) {
    return '世界 ${n}';
  }

  @override
  String fightLevel(String level) {
    return '挑战第 ${level} 关';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · 约 ${reps} 个俯卧撑';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return '连击 ×${n}';
  }

  @override
  String get levelCleared => '通关';

  @override
  String get outOfTime => '时间到';

  @override
  String get statPushUps => '俯卧撑';

  @override
  String get statTimeLeft => '剩余';

  @override
  String get statHpLeft => '剩余 HP';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return '完成时剩余 ${seconds} 秒可得第二颗星';
  }

  @override
  String thirdStarHint(String seconds) {
    return '完成时剩余 ${seconds} 秒可得第三颗星';
  }

  @override
  String get fightLostHint => '重玩之前的关卡多拿星星：星星能解锁更强的武器。';

  @override
  String get nextLevel => '下一关';

  @override
  String get tryAgain => '再试一次';

  @override
  String get adventureMap => '地图';

  @override
  String get nextKicker => '下一关';

  @override
  String nextLevelLine(String level, String hp) {
    return '第 ${level} 关 · HP ${hp}';
  }

  @override
  String get armory => '武器库';

  @override
  String get armoryBody => '星星可解锁武器。每个世界的怪物只会被该世界的武器或更强的武器伤到。';

  @override
  String get equipped => '已装备';

  @override
  String perPushUp(String damage) {
    return '每个俯卧撑 ${damage}';
  }

  @override
  String damagePerPushUp(String damage) {
    return '每个俯卧撑造成 ${damage} 伤害';
  }

  @override
  String wasWith(String damage, String weapon) {
    return '之前：${weapon} ${damage}';
  }

  @override
  String moreStars(String count) {
    return '还差 ${count} 颗星';
  }

  @override
  String get newWeapon => '新武器';

  @override
  String starsKicker(String count) {
    return '${count} 颗星';
  }

  @override
  String get weaponGauntlets => '黑铁护手';

  @override
  String get weaponKnuckles => '青铜指虎';

  @override
  String get weaponFang => '白银之牙';

  @override
  String get weaponHammer => '黄金战锤';

  @override
  String get weaponAxe => '铂金战斧';

  @override
  String get weaponSpear => '钻石长矛';

  @override
  String get weaponSword => '大师之剑';

  @override
  String get weaponCrownbreaker => '碎冠者';

  @override
  String clearFirst(String level) {
    return '先通过第 ${level} 关';
  }

  @override
  String needsWeapon(String weapon) {
    return '需要${weapon}';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return '只有${weapon}或更强的武器才能伤到它';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world}需要${weapon} · 还差 ${count} 颗星';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name} 已离开 · 这次没有再战';
  }

  @override
  String get obNext => '下一步';

  @override
  String get obRaceTitle => '和真人比拼。';

  @override
  String get obRaceBody => '60秒内做得多的人赢。对手用自己的手机实时参赛；没人在线时，你挑战的是对方录好的一组。';

  @override
  String get obRepsTitle => '只算完整的一次。';

  @override
  String get obRepsBody => '摄像头会看你下得多低、又起得多高。';

  @override
  String get obRepsDown => '下到金线以下';

  @override
  String get obRepsUp => '再起到上线以上';

  @override
  String get obRepsBoth => '两步都要双手撑地。只做一半不算——你的手机和对手的手机都一样。';

  @override
  String get obClimbTitle => '一路冲到 Master。';

  @override
  String get obClimbBody => '赢下比赛往上爬：七个段位，每个五级。';

  @override
  String get obAdventureTitle => '一个人练？';

  @override
  String get obAdventureBody => '冒险模式有140关俯卧撑对决，一关比一关难。';

  @override
  String get obGoldLine => '金线';

  @override
  String obCalibrationRule(String gold) {
    return '下到${gold}以下，再起到上线以上';
  }

  @override
  String get proTitleTop => '没有广告。';

  @override
  String get proTitleBottom => '只有俯卧撑。';

  @override
  String get proBody => '每场比赛都免费。Pro 会去掉所有比赛的广告。';

  @override
  String get proThanks => '广告已关闭。感谢升级 Pro。';

  @override
  String get removeAds => '去除广告';

  @override
  String get adNotice => '离开时会播放一条广告';

  @override
  String get adAskTitle => '广告让 outrepd 保持免费';

  @override
  String get adAskBody => '接下来 iPhone 会问你，是否允许 App 用你的活动来挑选广告。同意的话，广告会更合你的口味；不同意也照样会有广告，只是没那么相关。';

  @override
  String get adAskCamera => '这和摄像头无关：无论你怎么选，身体追踪都只在这部手机上进行。';

  @override
  String get adAskRemove => '改为去除广告';

  @override
  String get monsterIronColossus => '钢铁巨像';

  @override
  String get monsterScarab => '圣甲虫';

  @override
  String get monsterScarabPharaoh => '圣甲虫法老';

  @override
  String get monsterYeti => '雪人';

  @override
  String get monsterFrostYeti => '冰霜雪人';

  @override
  String get monsterYetiChieftain => '雪人首领';

  @override
  String get monsterGoldSoldier => '黄金士兵';

  @override
  String get monsterGoldKnight => '黄金骑士';

  @override
  String get monsterGoldKing => '黄金国王';

  @override
  String get monsterWisp => '鬼火';

  @override
  String get monsterWraith => '幽灵';

  @override
  String get monsterFrostLich => '冰霜巫妖';

  @override
  String get monsterCrystalDrake => '水晶飞龙';

  @override
  String get monsterCrystalDragon => '水晶巨龙';

  @override
  String get monsterDiamondWyrm => '钻石古龙';

  @override
  String get monsterShadowGuard => '暗影卫士';

  @override
  String get monsterShadowKnight => '暗影骑士';

  @override
  String get monsterTheMaster => '宗师';

  @override
  String get monsterPebbleGolem => '卵石魔像';

  @override
  String get monsterStoneGolem => '石头魔像';

  @override
  String get monsterOreGolem => '矿石魔像';

  @override
  String get monsterMinerGolem => '矿工魔像';

  @override
  String get monsterScarabGrub => '圣甲虫幼虫';

  @override
  String get monsterHornedScarab => '角圣甲虫';

  @override
  String get monsterScarabWarrior => '圣甲虫战士';

  @override
  String get monsterYetiCub => '雪人幼崽';

  @override
  String get monsterHornedYeti => '角雪人';

  @override
  String get monsterGoldRecruit => '黄金新兵';

  @override
  String get monsterGoldGuard => '黄金卫兵';

  @override
  String get monsterShade => '阴影';

  @override
  String get monsterIceSpecter => '冰霜幽魂';

  @override
  String get monsterCrystalHatchling => '水晶雏龙';

  @override
  String get monsterCrystalWhelp => '水晶幼龙';

  @override
  String get monsterShadowSquire => '暗影侍从';

  @override
  String get monsterShadowLord => '暗影领主';

  @override
  String monsterWarden(String name) {
    return '${name}守卫';
  }

  @override
  String get obPhoneSees => '手机应该看到的画面';

  @override
  String get obPhoneSeesBody => '从头顶到双手，大约一米远，保持俯卧撑姿势。';

  @override
  String get obUnder13 => '13岁以下';

  @override
  String get obOver13 => '13岁及以上';

  @override
  String get obFor13 => 'outrepd 适合13岁及以上的用户。';

  @override
  String get obUnder13Blocked => 'outrepd 适合13岁及以上的用户。等你13岁了再来吧，俯卧撑会一直在这里。';

  @override
  String get obBeforeYouLift => '开始之前';
}
