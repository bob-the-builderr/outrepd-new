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
  String get tabCrew => '战队';

  @override
  String get tabProfile => '我的';

  @override
  String get searchOpponent => '寻找对手';

  @override
  String get searchOpponentHint => '为你匹配同段位的选手';

  @override
  String get challengeFriend => '向好友挑战';

  @override
  String get trainWithCamera => '用摄像头训练';

  @override
  String get viewRoadmap => '查看晋级路线';

  @override
  String lpProgress(String lp, String left) {
    return '$lp / 100 LP · 距晋级还差 $left';
  }

  @override
  String winStreak(String count) {
    return '$count 连胜';
  }

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
  String get profile => '我的';

  @override
  String get settings => '设置';

  @override
  String get stats => '数据';

  @override
  String get edit => '编辑';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get skip => '跳过';

  @override
  String get totalMatches => '对战总数';

  @override
  String get bestWinStreak => '最高连胜';

  @override
  String get totalVolume => '累计举起重量';

  @override
  String get height => '身高';

  @override
  String get bodyweight => '体重';

  @override
  String get age => '年龄';

  @override
  String get editYourStats => '编辑个人数据';

  @override
  String get editStatsHint => '胜场、总量和段位靠打出来，不能手填。';

  @override
  String get changeName => '修改名字';

  @override
  String get changeNameLast => '这是最后一次修改，改完无法撤销。';

  @override
  String changeNameLeft(String total, String left) {
    return '一共有 $total 次机会，这次之后还剩 $left 次。';
  }

  @override
  String get changeNameUsedUp => '两次改名机会都用完了';

  @override
  String get yourPicture => '你的头像';

  @override
  String get yourPictureHint => '头像框由段位决定，晋级后会随之变化。';

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
  String titlesAndStreak(String owned, String total, String streak) {
    return '$total 个称号已得 $owned 个 · 连续 $streak 天';
  }

  @override
  String get crew => '战队';

  @override
  String get myCrew => '我的战队';

  @override
  String get rankings => '排行';

  @override
  String get trainWithCrew => '和战队一起练';

  @override
  String get trainWithCrewHint => '同一个名字下最多 20 人，一起追每周目标，一起往战队榜上爬。';

  @override
  String get createCrew => '创建战队';

  @override
  String get createCrewHint => '为战队命名，选择队徽，并邀请你的伙伴';

  @override
  String get joinOpenCrew => '加入公开战队';

  @override
  String get joinOpenCrewHint => '面向所有人开放的战队';

  @override
  String get yourInvites => '你的邀请';

  @override
  String get yourInvitesHint => '点名要你的战队';

  @override
  String get joinWithCode => '用邀请码加入';

  @override
  String get joinWithCodeHint => '队员给你的六位码';

  @override
  String get topCrewsThisWeek => '本周战队榜';

  @override
  String get members => '成员';

  @override
  String get repsEach => '人均次数';

  @override
  String get rank => '名次';

  @override
  String get weeklyGoal => '每周目标';

  @override
  String get weeklyGoalDone => '本周目标已达成';

  @override
  String goalRemaining(String reps, String days) {
    return '还差 $reps 次 · 剩 $days 天';
  }

  @override
  String get goalDoneHint => '本周结束时，徽章人人有份。';

  @override
  String get startCrewWar => '发起战队对抗';

  @override
  String get startCrewWarHint => '七天，两队同时计数，人均次数高的一方获胜。';

  @override
  String get whoIsPulling => '谁在带动战队';

  @override
  String get thisWeek => '本周';

  @override
  String get inviteLifters => '邀请队友';

  @override
  String get referralCode => '邀请码';

  @override
  String get inviteLink => '邀请链接';

  @override
  String get leaveCrew => '退出战队';

  @override
  String get owner => '队长';

  @override
  String get crewTable => '战队榜';

  @override
  String get repsPerMember => '人均次数';

  @override
  String seasonResets(String days) {
    return '$days 天后清零 —— 所有人重新站在同一起点';
  }

  @override
  String get rankingExplained => '战队按人均次数排名，而不是总数，否则人多的战队光靠人数就能赢。';

  @override
  String get leaderboard => '排行榜';

  @override
  String get global => '全球';

  @override
  String get myCountry => '本国';

  @override
  String yourFriends(String count) {
    return '你的好友（$count）';
  }

  @override
  String get challenge => '挑战';

  @override
  String get notifications => '通知';

  @override
  String get pickMovement => '选择动作';

  @override
  String get anyExercise => '任意动作';

  @override
  String get anyExerciseHint => '开始你的组次，系统会在过程中识别动作';

  @override
  String get start => '开始';

  @override
  String get finish => '结束';

  @override
  String get reps => '次';

  @override
  String get secondsHeld => '秒保持';

  @override
  String get learningMovement => '正在学习你的动作——计数马上出现';

  @override
  String get recalibrate => '重新校准';

  @override
  String get resetCount => '计数清零';

  @override
  String get checksForm => '检查动作';

  @override
  String get counts => '计入';

  @override
  String get time => '计时';

  @override
  String get howManyReally => '你实际做了多少个？';

  @override
  String get howManyReallyHint => '请填写你自己的计数，而不是应用的计数。之后将以此衡量计数器的准确度。';

  @override
  String get appearance => '外观';

  @override
  String get theme => '主题';

  @override
  String get darkMode => '深色模式';

  @override
  String get language => '语言';

  @override
  String get units => '单位';

  @override
  String get weight => '重量';

  @override
  String get notificationsSection => '通知';

  @override
  String get privacy => '隐私';

  @override
  String get matches => '对战';

  @override
  String get data => '数据';

  @override
  String get about => '关于';

  @override
  String get dangerZone => '危险操作';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get openCrews => '公开战队';

  @override
  String get openCrewsHint => '这些战队面向所有人开放，选择其一即可直接加入。';

  @override
  String get yourInvitesSubtitle => '点名邀请你的战队。';

  @override
  String get pickOpponent => '选择对手';

  @override
  String get accept => '接受';

  @override
  String get join => '加入';

  @override
  String get copy => '复制';

  @override
  String get copied => '邀请链接已复制';

  @override
  String season(String name) {
    return '$name 赛季';
  }

  @override
  String challengeSent(String name) {
    return '已向 $name 发出挑战';
  }

  @override
  String get inviteFriendPrivate => '邀请好友进行私人对战';

  @override
  String get joinWithCodePaste => '粘贴队员发给你的六位码。';

  @override
  String get enterTheCode => '请输入 6 位邀请码';

  @override
  String get followingDevice => '当前跟随系统设置';

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
  String get visEveryoneHint => '任何人都能打开你的主页';

  @override
  String get visFriendsHint => '只有你添加过的人';

  @override
  String get visNobodyHint => '你的主页保持私密';

  @override
  String get matchInvites => '对战邀请';

  @override
  String get matchResults => '对战结果';

  @override
  String get friendRequestsLabel => '好友申请';

  @override
  String get crewActivity => '战队动态';

  @override
  String get rankChanges => '段位变动';

  @override
  String get weeklySummary => '每周总结';

  @override
  String get soundLabel => '音效';

  @override
  String get vibration => '振动';

  @override
  String get whoCanSeeProfile => '谁能看到我的主页';

  @override
  String get profileVisibility => '主页可见范围';

  @override
  String get showOnLeaderboards => '在排行榜上展示我';

  @override
  String get allowMatchInvites => '允许对战邀请';

  @override
  String get allowFriendRequests => '允许好友申请';

  @override
  String get showHeightWeight => '显示身高体重';

  @override
  String get showHeightWeightHint => '关闭后身体数据只有你自己看得到';

  @override
  String get autoAcceptFriends => '自动接受好友的邀请';

  @override
  String get restTimerBetweenSets => '组间休息计时';

  @override
  String get exportData => '导出我的数据';

  @override
  String get clearCache => '清除缓存';

  @override
  String get cacheCleared => '缓存已清除';

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
  String get resetProgress => '重置我的进度';

  @override
  String get resetProgressTitle => '要重置进度吗？';

  @override
  String get resetProgressBody => '段位、LP 和对战记录都会归零，且无法撤销。';

  @override
  String get actionReset => '重置';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get deleteAccountTitle => '要删除账号吗？';

  @override
  String get deleteAccountBody => '你的主页、战队以及打过的每一场对战都会被永久删除。';

  @override
  String get actionDelete => '删除';

  @override
  String get needsServer => '此功能需要服务器支持，目前尚未接入';

  @override
  String get getStarted => '开始吧';

  @override
  String get skipToApp => '直接进入应用';

  @override
  String get achievements => '成就';

  @override
  String get unlocked => '已解锁';

  @override
  String get roadTitle => '传奇之路';

  @override
  String get allTiers => '全部段位';

  @override
  String get topTier => '最高段位';

  @override
  String lpToGo(String lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => '你已经全部解锁';

  @override
  String unlocksAt(String tier) {
    return '$tier 解锁';
  }

  @override
  String get matchedSameGroup => '系统会为你匹配训练同一肌群的对手。';

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
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierStone => '石';

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
  String get tierMythic => '神话';

  @override
  String get tierLegend => '传奇';

  @override
  String get rewardStone => '石纹边框';

  @override
  String get rewardBronze => '青铜徽章';

  @override
  String get rewardSilver => '白银徽章';

  @override
  String get rewardGold => '黄金徽章';

  @override
  String get rewardPlatinum => '铂金徽章';

  @override
  String get rewardDiamond => '钻石徽章';

  @override
  String get rewardMaster => '大师徽章';

  @override
  String get rewardMythic => '神话徽章';

  @override
  String get rewardLegend => '传奇徽章';

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
  String get yearsSuffix => '岁';

  @override
  String get yourCrew => '你的战队';

  @override
  String get crewName => '战队名称';

  @override
  String get motto => '口号';

  @override
  String get mottoHint => '这支战队代表什么？';

  @override
  String get country => '国家';

  @override
  String get whoCanJoin => '谁可以加入';

  @override
  String get minimumRank => '最低段位';

  @override
  String get anyone => '任何人';

  @override
  String get emblem => '队徽';

  @override
  String get colour => '颜色';

  @override
  String get createCrewButton => '创建战队';

  @override
  String get ownerNote => '你将成为队长，战队最多可容纳 20 名成员。';

  @override
  String get searchCountries => '搜索国家';

  @override
  String get noCountryMatch => '没有匹配的国家';

  @override
  String get nameTooShort => '请为战队取一个至少三个字符的名称';

  @override
  String get privOpen => '公开';

  @override
  String get privRequest => '申请加入';

  @override
  String get privInviteOnly => '仅限邀请';

  @override
  String get privOpenHint => '持有邀请码的人可直接加入';

  @override
  String get privRequestHint => '本人申请，由管理员批准';

  @override
  String get privInviteOnlyHint => '只能通过直接邀请加入';

  @override
  String get embStrength => '力量';

  @override
  String get embCombat => '格斗';

  @override
  String get embBeasts => '野兽';

  @override
  String get embElements => '元素';

  @override
  String get embHonours => '荣誉';

  @override
  String get embSymbols => '符号';

  @override
  String get ob1Title => '把每一次训练\n变成一场对决';

  @override
  String get ob1Body => '记录你的训练，与练同一肌群的人正面较量。';

  @override
  String get ob2Title => '向好友\n发起挑战';

  @override
  String get ob2Body => '发出私人邀请，一决谁练得更狠。';

  @override
  String get ob3Title => '一路提升段位';

  @override
  String get ob3Body => '每场胜利都带来 LP，从「石」一路打到「传奇」。';

  @override
  String get ob4Title => '独自坚持\n并不容易';

  @override
  String get ob4Body => '没人看着的时候，最后一组很容易草草收场。';

  @override
  String get ob5Title => '成为\n传奇';

  @override
  String get ob5Body => '坚持会累积。到场、压过对手、往上走。';

  @override
  String get letsGo => '开始吧';

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
  String get ttl_bronze_tier => '走出石阶';

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
  String get ttl_mythic_tier => '神话';

  @override
  String get tdesc_mythic_tier => '达到神话段位';

  @override
  String get ttl_legend_tier => '传奇';

  @override
  String get tdesc_legend_tier => '达到传奇';

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
  String get ttl_iron_hold => '铁掌';

  @override
  String get tdesc_iron_hold => '平板支撑坚持两分钟';

  @override
  String get ttl_statue => '雕像';

  @override
  String get tdesc_statue => '平板支撑坚持五分钟';

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
  String get ttl_joined_up => '已入队';

  @override
  String get tdesc_joined_up => '加入一支战队';

  @override
  String get ttl_backbone => '中流砥柱';

  @override
  String get tdesc_backbone => '连续四周位居战队榜首';

  @override
  String get ttl_cornerstone => '基石';

  @override
  String get tdesc_cornerstone => '连续十二周位居战队榜首';

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
  String get finish2 => '完成';

  @override
  String get qExperience => '你的训练经验\n有多少？';

  @override
  String get expBeginner => '新手 – 试过几次';

  @override
  String get expIntermediate => '进阶 – 有规律训练';

  @override
  String get expAdvanced => '资深 – 多年经验';

  @override
  String get qGoal => '你最重要的\n健身目标是什么？';

  @override
  String get goalStronger => '变得更强';

  @override
  String get goalConsistent => '变得更规律';

  @override
  String get goalLean => '减重并练出线条';

  @override
  String get goalMass => '增加肌肉量';

  @override
  String get aboutYou => '这条路，全都关于你自己……';

  @override
  String get qThinkAbout => '你多久会想一次\n要把身材练回来？';

  @override
  String get freqNever => '从不';

  @override
  String get freqSometimes => '偶尔';

  @override
  String get freqOften => '经常';

  @override
  String get freqAllTime => '一直在想';

  @override
  String get qEnergy => '训练时你的\n状态如何？';

  @override
  String get energyLow => '很低，整天都觉得被掏空';

  @override
  String get energyDrops => '练到一半状态就掉下来';

  @override
  String get energyHard => '最后一组很难顶住';

  @override
  String get energyHigh => '从头到尾都高且稳定';

  @override
  String get stProgress => '有时候练着练着，很难看出自己有进步';

  @override
  String get stEffortTitle => '没人看见的努力\n最容易放弃';

  @override
  String get stEffortBody => '当没有人可以较劲时，进步显得缓慢，努力也显得没有意义';

  @override
  String get stAloneTitle => '一个人训练\n很枯燥';

  @override
  String get stAloneBody => '没人在看，没人在数。少做一次，甚至整组跳过，都太容易了';

  @override
  String get qName => '我们该怎么\n称呼你？';

  @override
  String get nameHint => '至少三个字符，这是对手会看到的名字。';

  @override
  String get basicInfo => '好！接下来是一些\n基本信息';

  @override
  String get qAge => '你今年多大？';

  @override
  String get qWeight => '你目前的\n体重是多少？';

  @override
  String get weightWhy => '计算段位需要用到体重。';

  @override
  String get privateNote => '你的信息是私密的，不会分享给任何人。';

  @override
  String get qHeight => '你的身高是多少？';

  @override
  String get qRelate => '你认同\n下面这句话吗？';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get grindTitle => '有对手在\n这份苦练就不一样了';

  @override
  String get grindBody => '每场对战都让你面对一个真实的对手：把该做的做完，证明谁练得更狠。';

  @override
  String get allSet => '一切就绪！';

  @override
  String welcomeLifter(String name) {
    return '欢迎你，$name。该去找第一个对手了。';
  }

  @override
  String get lifter => '选手';

  @override
  String get enterApp => '进入 OUTREPD';

  @override
  String get commitTitle => '现在，为你自己的这条路\n立个约定';

  @override
  String get holdLogo => '长按标志，确认你已经准备好';

  @override
  String get expNone => '我从没训练过';

  @override
  String get iAm => '我……';

  @override
  String get finishMatchQ => '结束这场对战？';

  @override
  String get finishMatchBody => '你的总容量将被锁定，并与对手比较。';

  @override
  String get keepGoing => '继续';

  @override
  String get forfeitQ => '认输退出？';

  @override
  String get forfeitBody => '现在离开会扣除 LP。';

  @override
  String get stay => '留下';

  @override
  String get forfeit => '认输';

  @override
  String get pickExercises => '选择你要练的动作';

  @override
  String matchingWith(String muscle) {
    return '正在为你匹配同段位的对手 · $muscle';
  }

  @override
  String get getReady => '准备';

  @override
  String get timeLeft => '剩余时间';

  @override
  String vsName(String name) {
    return '对阵 $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '总容量 $unit';
  }

  @override
  String get finishMatch => '结束对战';

  @override
  String get kgHint => '公斤';

  @override
  String get repsHint => '次数';

  @override
  String get addSet => '添加一组';

  @override
  String get matchComplete => '对战结束';

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
  String get achRivalry => '宿敌之争';

  @override
  String get achRivalryHint => '击败同一名对手 3 次';

  @override
  String get nWonTitle => '你赢了！';

  @override
  String nWonBody(String name, String muscle) {
    return '你在$muscle日击败了 $name';
  }

  @override
  String get nFriendTitle => '新的好友申请';

  @override
  String nFriendBody(String name) {
    return '$name 想加你为好友';
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
  String get nameTooShortInline => '请输入至少三个字符的名字';

  @override
  String get whyName => '对手会在每一个成绩旁看到它';

  @override
  String get whyExperience => '我们会为你匹配同水平的人';

  @override
  String get whyGoal => '最初推荐的动作由此决定';

  @override
  String get whyAge => '年龄会影响用来衡量你的力量标准';

  @override
  String get whyWeight => '段位比较的是相对体重的重量，而不是绝对公斤数';

  @override
  String get whyHeight => '与体重一起用来设定公平的标准';

  @override
  String get whyHabits => '这会决定提醒和我们建议的每周目标';

  @override
  String get transitionPartOfIt => '……那就让你真正成为其中一员吧。';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get usernamePlaceholder => '名字';

  @override
  String get stRoutine => '我不知道哪个部位真正需要练，所以常常重复同一套动作';

  @override
  String get shortIn => '英寸';

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
  String membersCount(String n) {
    return '$n 名成员';
  }

  @override
  String eachCount(String n) {
    return '人均 $n';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get countWithCamera => '用摄像头计数';

  @override
  String get youWin => '你赢了！';

  @override
  String get defeated => '失败';

  @override
  String get fillWholeNumbers => '三项都请填写整数';

  @override
  String heightRange(String min, String max, String unit) {
    return '身高需在 $min 到 $max $unit 之间';
  }

  @override
  String weightRange(String min, String max, String unit) {
    return '体重需在 $min 到 $max $unit 之间';
  }

  @override
  String ageRange(String min, String max) {
    return '年龄需在 $min 到 $max 之间';
  }

  @override
  String get discPush => 'Push';

  @override
  String get discPull => 'Pull';

  @override
  String get discLegs => 'Legs';

  @override
  String get discPushHint => 'Chest, shoulders and triceps';

  @override
  String get discPullHint => 'Back and biceps';

  @override
  String get discLegsHint => 'Quads, hamstrings and core';

  @override
  String get pickYourThree => 'Pick your three';

  @override
  String get pickThreeHint =>
      'Both of you lift all six — your three and theirs';

  @override
  String roundOf(String n, String total) {
    return 'Round $n of $total';
  }

  @override
  String get rest => 'Rest';

  @override
  String get work => 'Work';

  @override
  String get nextUp => 'Next up';

  @override
  String picksLeft(String n) {
    return '$n left to pick';
  }

  @override
  String get yourPick => 'Your pick';

  @override
  String get theirPick => 'Their pick';

  @override
  String secondsOfWork(String n) {
    return '$n seconds of work';
  }

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String toPromotion(String n) {
    return '距晋级还差 $n';
  }

  @override
  String get noFriendsTitle => '还没有好友';

  @override
  String get noFriendsBody => '添加好友后，随时可以向对方发起私人对战。';

  @override
  String get noMatchesTitle => '还没有对战';

  @override
  String get noMatchesBody => '第一场会出现在这里，无论输赢。';

  @override
  String get noNotificationsTitle => '暂无新消息';

  @override
  String get noNotificationsBody => '对战邀请、结果和好友申请都会送到这里。';

  @override
  String roundDone(String n) {
    return '第 $n 回合结束';
  }

  @override
  String get bestRoundYet => '目前最好的一回合';

  @override
  String get countedThat => '本轮计数';

  @override
  String get thatIsRight => '没错';

  @override
  String get useMyCount => '用我的计数';

  @override
  String get confirmHint => '如果摄像头数错了，请修改。';

  @override
  String pickNMore(String n) {
    return '再选 $n 个';
  }

  @override
  String get findOpponent => '寻找对手';
}
