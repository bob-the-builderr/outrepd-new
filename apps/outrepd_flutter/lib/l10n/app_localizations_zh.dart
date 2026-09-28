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
  String get passwordHint => '密码';

  @override
  String get codeHint => '验证码';

  @override
  String get createAccountTitle => '创建账户';

  @override
  String get createAccountBody => '添加邮箱和密码，让这个账户不再只依赖这一部手机。';

  @override
  String get createAccountAction => '创建账户';

  @override
  String get signInTitle => '登录';

  @override
  String get signInBody => '使用账户的邮箱和密码登录。';

  @override
  String get signInAction => '登录';

  @override
  String get switchToSignIn => '已有账户？登录';

  @override
  String get switchToSignUp => '第一次来？创建账户';

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
  String get orDivider => '或';

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
  String get usernameHint => '用户名';

  @override
  String get usernameLabel => '用户名';

  @override
  String get emailLabel => '电子邮箱';

  @override
  String get passwordLabel => '密码';

  @override
  String get passwordMinLength => '至少8个字符';

  @override
  String get logInSubtitle => '登录以保留你的段位。';

  @override
  String get forgotPassword => '忘记密码?';

  @override
  String resetPasswordSent(String email) {
    return '如果 $email 存在账户,重置链接正在发送中。';
  }

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
  String get socialLinkFailed => '无法完成登录。请重试。';

  @override
  String get showLabel => '显示';

  @override
  String get hideLabel => '隐藏';

  @override
  String get resetPasswordTitle => '设置新密码';

  @override
  String get resetPasswordBody => '为你的账户选择新密码。';

  @override
  String get setPasswordAction => '设置密码';

  @override
  String get wrongEmailOrPassword => '邮箱或密码错误。';

  @override
  String get enterCodeTitle => '输入验证码';

  @override
  String codeInstructions(String email) {
    return '请输入发送到 $email 的验证码。';
  }

  @override
  String get verifyAction => '验证';

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
  String get height => '身高';

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
  String get usernameInvalidLength => '必须为4到20个字符，仅限字母和数字';

  @override
  String get usernameChanged => '用户名已更改';

  @override
  String get usernameAlreadyChangedBody => '你已经用过唯一一次改名机会——每个账号只能改一次用户名。';

  @override
  String get gallery => '相册';

  @override
  String get camera => '拍照';

  @override
  String get orPickOurs => '或者从我们准备的里挑一个';

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
  String get recalibrate => '重新校准';

  @override
  String get resetCount => '计数清零';

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
  String get units => '单位';

  @override
  String get weight => '重量';

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
  String challengeSent(String name) {
    return '已向 $name 发出挑战';
  }

  @override
  String get weightUnitTitle => '重量单位';

  @override
  String get heightUnitTitle => '身高单位';

  @override
  String get unitKg => '千克 (kg)';

  @override
  String get unitLb => '磅 (lb)';

  @override
  String get unitCm => '厘米 (cm)';

  @override
  String get unitFt => '英尺与英寸';

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
  String get needsServer => '此功能需要服务器支持，目前尚未接入';

  @override
  String get achievements => '成就';

  @override
  String get roadTitle => '大师之路';

  @override
  String get allTiers => '全部段位';

  @override
  String get topTier => '最高段位';

  @override
  String lpToGo(String lp) {
    return '$lp LP';
  }

  @override
  String get roomFriendly => '房间对战是友谊赛，不影响你的段位。';

  @override
  String get createRoom => '创建房间';

  @override
  String get enterCode => '输入邀请码';

  @override
  String get joinRoom => '加入房间';

  @override
  String get shareThisCode => '分享这个码';

  @override
  String get codeCopied => '已复制邀请码';

  @override
  String get pickMuscleAndStart => '选择肌群并开始';

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
  String get shortKg => '公斤';

  @override
  String get shortLb => '磅';

  @override
  String get shortCm => '厘米';

  @override
  String get shortFt => '英尺';

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
  String get stay => '留下';

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
  String get mgBack => '背';

  @override
  String get mgLegs => '腿';

  @override
  String get mgShoulders => '肩';

  @override
  String get mgArms => '手臂';

  @override
  String get mgCore => '核心';

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
    return '$n 周前';
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
  String get addFriend => '添加';

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
  String get findPeople => '找人';

  @override
  String get noRankYet => '还没有段位';

  @override
  String placementsForFirstTier(String count) {
    return '完成 $count 场定位赛即可获得首个段位。';
  }

  @override
  String get startPlacements => '开始定位赛';

  @override
  String get unranked => '未定级';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done/$total · 每场 $seconds 秒';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done/$total · 还差 $left 场定段';
  }

  @override
  String placementsForTier(String count) {
    return '完成 $count 场定位赛即可查看你的段位。';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '已完成 $done/$total 场定位赛';
  }

  @override
  String get practiceFirst => '先练一下';

  @override
  String get nextPlacement => '下一场定位赛';

  @override
  String get noConnection => '没有网络';

  @override
  String get practiceOffline => '离线练习';

  @override
  String get retry => '重试';

  @override
  String get youWonPlain => '你赢了';

  @override
  String opponentDisconnected(String name) {
    return '$name 断线了';
  }

  @override
  String get forfeitNoMargin => '对手退出 · 分差不计';

  @override
  String get findAnotherMatch => '再找一场';

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
  String get noConnectionBody => '对决需要网络。练习离线也能用，计数会稍后同步。';

  @override
  String get getBackInFrame => '回到画面里';

  @override
  String get clockStillRunning => '计时还在走，但没有计数。';

  @override
  String get giveUp => '放弃';

  @override
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss LP';
  }

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
  String get yourRankCard => '你的段位卡';

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
  String get obHowTitle => '三件事，然后就能开始。';

  @override
  String get obHow1 => '把手机立在地上';

  @override
  String get obHow1Body => '靠墙放，在你前方一米处。';

  @override
  String get obHow2 => '摄像头数你的次数';

  @override
  String get obHow2Body => '每一次都检查深度。半程不算。';

  @override
  String get obHow3 => '六十秒，对上一个人';

  @override
  String get obHow3Body => '赢了上升，输了下降。规则对谁都一样。';

  @override
  String get obTwoThings => '两件小事。';

  @override
  String get obAgeQuestion => '你多大了？';

  @override
  String get obUnder16 => '不满 16 岁';

  @override
  String get obOver16 => '16 岁及以上';

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
  String get obUnder16Blocked => 'outrepd 面向 16 岁及以上。到了年纪再来——俯卧撑跑不了。';

  @override
  String get obCameraTitle => 'outrepd 需要用摄像头';

  @override
  String get obCameraBody => '它看着你的身体动作来计数。没有别的办法。';

  @override
  String get obCameraPrivateTitle => '没有任何东西离开你的手机';

  @override
  String get obCameraPrivateBody => '姿态识别在本机运行。除非你自己发布，否则不会上传任何视频。';

  @override
  String get obWhyNeeded => '为什么需要这个？';

  @override
  String get obPlacementTitle => '把手机放在地上';

  @override
  String get obPlacementBody => '靠墙放，大约在你前方一米。';

  @override
  String get obOneMetre => '约1米';

  @override
  String get obFullBody => '全身都在画面里';

  @override
  String get obCheckHandsFeet => '手和脚都看得见';

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
  String get obFramingAnkles => '脚踝';

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
  String get obCreateAccountBody => '创建账号，保住你的次数、段位和战绩。';

  @override
  String get obSaveProgress => '保存我的进度';

  @override
  String obSaveYourReps(String count) {
    return '保存你的 $count 次';
  }

  @override
  String get obOneTap => '只需一个邮箱和一个密码。';

  @override
  String get obContinueApple => '使用 Apple 继续';

  @override
  String get obContinueGoogle => '使用 Google 继续';

  @override
  String get obContinueEmail => '使用邮箱继续';

  @override
  String get obSignInFootnote => '只用来保住你的账号。我们从不替你发布任何内容。';

  @override
  String get obPickName => '取个名字';

  @override
  String get obPickNameBody => '对手看到的就是这个。之后可以改。';

  @override
  String get obAvailable => '可以用';

  @override
  String get obTaken => '已被占用';

  @override
  String get obYourAvatar => '你的头像';

  @override
  String get obAddPhoto => '添加照片';

  @override
  String get obPlacementsBody => '五场对决决定你的起始段位。目前还不会记在你头上。';

  @override
  String get obFindFirstOpponent => '找第一个对手';

  @override
  String get obGotIt => '知道了';

  @override
  String get obFormMixed => '不稳定';

  @override
  String get obWelcomeBack => '欢迎回来';

  @override
  String get obWelcomeBackBody => '使用邮箱和密码登录。';

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
  String get accNothingYetBody => '每次对决结束后你确认次数，那一组就会和你报的数对照一次。结果会出现在这里。';

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
  String get lpRowWin => '胜利';

  @override
  String get lpRowLoss => '失败';

  @override
  String get lpRowOpponent => '对手段位';

  @override
  String get lpRowMargin => '差距';

  @override
  String get lpRowDepth => '深度';

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
}
