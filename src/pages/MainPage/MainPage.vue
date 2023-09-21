<template>
  <div class="page-content d-flex flex-column">
    <PageHeader title="主页">
      <v-menu v-if="this.$store.state.user.uid == 1" ref="menu" v-model="datePicker" :close-on-content-click="false" :return-value.sync="dates" offset-y>
        <template v-slot:activator="{ on, attrs }">
          <v-btn class="ml-2" text v-bind="attrs" v-on="on" color="primary" :disabled="loading || datePicker">
            <v-icon size="20" style="padding-top: 2px">mdi-calendar-blank</v-icon>
            <span> 日期选择 </span>
          </v-btn>
        </template>
        <v-date-picker v-model="dates" no-title scrollable locale="zh-cn" color="primary" first-day-of-week="1"
          :day-format="dayFormat" min="2021-01-01" :max="parseDate(new Date())">
          <v-spacer></v-spacer>
          <v-btn text color="primary" @click="datePicker = false"> 取消 </v-btn>
          <v-btn text color="primary" @click="
            $refs.menu.save(dates);
          loadData();
          ">
            确定
          </v-btn>
        </v-date-picker>
      </v-menu>
    </PageHeader>
    <!-- <div>
      <v-col class="ml-6" cols="1">
        <v-row>
          <span class="group-title"> 日期选择 </span>
        </v-row>
        <v-row>
          <v-menu ref="menu" v-model="datePicker" :close-on-content-click="false" :return-value.sync="dates" offset-y>
            <template v-slot:activator="{ on, attrs }">
              <v-text-field
                class="date-picker-textfield search-input"
                style="width: 120px"
                v-model="dates"
                readonly
                v-bind="attrs"
                v-on="on"
                outlined
                dense
                hide-details
                :disabled="loading"
                color="primary"
              ></v-text-field>
            </template>
            <v-date-picker
              v-model="dates"
              no-title
              scrollable
              locale="zh-cn"
              color="primary"
              first-day-of-week="1"
              :day-format="dayFormat"
              min="2021-01-01"
              :max="parseDate(new Date())"
            >
              <v-spacer></v-spacer>
              <v-btn text color="primary" @click="datePicker = false"> 取消 </v-btn>
              <v-btn
                text
                color="primary"
                @click="
                  $refs.menu.save(dates);
                  loadData();
                "
              >
                确定
              </v-btn>
            </v-date-picker>
          </v-menu>
        </v-row>
      </v-col>
    </div> -->

    <v-container fluid id="mainContainer" v-if="this.$store.state.user.permission.f.s">
      <div class="dashboard-page mt-2 pt-2">
        <span class="ml-6 text--secondary">{{ dates }}</span>

        <v-row class="mt-1">
          <v-col cols="4">
            <v-card outlined class="ml-6 mx-1 mb-1" @click="test()">
              <v-card-title>
                <p class="text-body-2">当日订单总成交额</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center">{{ amountFormat(realTotalAmount) ? amountFormat(realTotalAmount) : "" }}
                </p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card outlined class="ml-3 mr-3 mx-1 mb-1">
              <v-card-title>
                <p class="text-body-2">EBC收录成交额</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center">{{ amountFormat(totalAmount) ? amountFormat(totalAmount) : "" }}</p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card outlined class="mr-6 mx-1 mb-1">
              <v-card-title>
                <p class="text-body-2">EBC未收录成交额</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center">{{ amountFormat(realTotalAmount - totalAmount) ?
                  amountFormat(realTotalAmount - totalAmount) : "" }}</p>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="4">
            <v-card outlined class="ml-6 mx-1 mb-1">
              <v-card-title>
                <p class="text-body-2">总订单数</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center">{{ amountFormat(mainPageCardOrderCount, null, 0) ?
                  amountFormat(mainPageCardOrderCount, null, 0) : "" }}</p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card outlined class="ml-3 mr-3 mx-1 mb-1">
              <v-card-title>
                <p class="text-body-2">真实订单数</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center">
                  {{ amountFormat(mainPageCardActualOrderCount, null, 0) ? amountFormat(mainPageCardActualOrderCount,
                    null, 0) : "" }}
                </p>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col cols="4">
            <v-card outlined class="mr-6 mx-1 mb-1">
              <v-card-title>
                <p class="text-body-2">售后毛利润</p>
              </v-card-title>
              <v-card-text>
                <p class="text-h3 text-center">{{ amountFormat(totalProfit) ? amountFormat(totalProfit) : "" }}</p>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
        <v-divider class="my-6"></v-divider>
        <span class="ml-6 text--secondary">{{ dates }}</span>
        <p class="mt-5 ml-6 text-body-2 text--secondary">最佳运营：</p>

        <p v-for="i in [0, 1, 2, 3, 4, 5]" class="mt-3 ml-6 text-body-2 text--secondary" :key="i">
          {{ ratings[i]?.name }}，总成交额：{{ amountFormat(ratings[i]?.totalAmount) }}
          <v-icon size="15" style="padding-bottom: 2px">mdi-currency-cny</v-icon> ，售后毛利润:
          {{ amountFormat(ratings[i]?.calculatedActualProfit) }}<v-icon size="15"
            style="padding-bottom: 2px">mdi-currency-cny</v-icon>
        </p>

        <p class="mt-10 ml-6 text-body-2 text--secondary">鸡汤文：</p>
        <p class="ml-6 text-body-2 text--secondary">{{ quotes[Math.floor(Math.random() * quotes.length)] }}</p>
      </div>
    </v-container>

    <div v-if="this.$store.state.user.uid != 1" style="text-align: center;">
      <img src="../../../public/ebc.png" style="margin-top: 30vh;" />
    </div>
  </div>
</template>

<script>
// import axios from "axios";

// import VChart from "vue-echarts";
import { mapState } from "vuex";
import { TooltipComponent, GridComponent, LegendComponent, MarkLineComponent, TitleComponent, ToolboxComponent } from "echarts/components";
import { BarChart, LineChart, PieChart } from "echarts/charts";
import { use } from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";

import PageHeader from "@/components/PageHeader";
import { getProfitReport } from "@/settings/profitReport";
import { getRealTotalAmount } from "@/settings/order";

import { javaUTCDateToString } from "@/libs/utils";
import { amountBeautify } from "@/libs/utils";

use([PieChart, TooltipComponent, GridComponent, LegendComponent, MarkLineComponent, BarChart, LineChart, CanvasRenderer, TitleComponent, ToolboxComponent]);

export default {
  name: "MainPage",
  components: {
    PageHeader,
    // VChart,
  },
  data() {
    return {
      datePicker: false,
      ratings: [],
      mainPageCardActualOrderCount: 0,
      mainPageCardOrderCount: 0,
      totalAmount: 0,
      totalProfit: 0,
      profitItems: [],
      observer: null,
      dates: "",
      loading: false,

      realTotalAmount: 0,

      quotes: [
        "言语本来应当是思想的仆人，但却往往变成思想的主人。——克鲁劳",
        "伟大的工作，并不是用力量而是用耐心去完成的。——约翰逊",
        "没有伟大的意志力，便没有雄才大略。——巴尔扎克",
        "在人的生活中最主要的是劳动训练。没有劳动就不可能有正常人的生活。——卢梭",
        "青年应当有朝气，敢作为。——鲁迅",
        "梦是心灵的思想，是我们的秘密真情。——杜鲁门·卡波特",
        "涓滴之水终能够磨损大石，不是由于它力量强大，而是由于昼夜不舍的滴坠。——贝多芬",
        "成功就像一座平衡的秤，一边是努力，一边是快乐；付出的多，收获的也多。——傅佩荣",
        "青春短暂，请记住最初的梦想。我的梦想先生和姑娘们，加油。——克隽逸",
        "为人类的幸福而劳动，这是多么壮丽的事业，这个目标有多么伟大。——圣西门",
        "自我控制是最强者的本能。——萧伯纳",
        "宿命论是那些缺乏意志力的弱者的借口。——罗曼·罗兰",
        "要真正了解一个人，需在不幸中考察他。——法国皇帝拿破仑。B.",
        "一个能思想的人，才真是一个力量无边的人。——巴尔扎克",
        "立志在坚不欲说，成功在久不在速。——张孝祥",
        "把每一件简单的事做好就是不简单；把每一件平凡的事做好就是不平凡。——张瑞敏",
        "夜把花悄悄地开放了，却让白日去领受谢词。——泰戈尔",
        "明者因时而变，知者随事而制。——桓宽",
        "没有人会感觉到，青春正在消逝，但任何人都会感觉到，青春已经消逝。——小塞涅卡",
        "一个人如果胸无大志，既使再有壮丽的举动也称不上是伟人。——拉罗什夫科",
        "成功的人，都有浩然气概，他们都是大胆的勇敢的，他们的字典上，是没有“惧怕”两个字的。——卡耐基",
        "世人缺乏的是毅力，而非气力。——雨果",
        "非学无以广才，非志无以成学。——诸葛亮",
        "所有伟大的事迹和伟大的思想都有荒谬的开头。——加缪",
        "要正直地生活，别想入非非！要诚实地工作，才能前程远大。——陀思妥耶夫斯基",
        "学而不思则罔，思而不学则殆。——孔子",
        "为世界进文明，为人类造幸福，以青年之我，创建青春之家庭，青春之国家，青春之民族，青春之人类，青春之地球，青春之宇宙，资以乐其无涯之生。——李大钊",
        "我死国生，我死犹荣，身虽死精神长生，成功成仁，实现大同。——赵博生",
        "没有人能平安无事度过一生。——埃斯库罗斯",
        "人生的道路都是由心来描绘的。所以，无论自己处于多么严酷的境遇之中，心头都不应为悲观的思想所萦绕。——稻盛和夫",
        "懒人老是找不到给他干的活。——沃维纳格",
        "才气就是长期的坚持不懈。——福楼拜",
        "人最凶恶的敌人，就是他的意志力的薄弱和愚蠢。——高尔基",
        "被克服的困难就是胜利的契机。——丘吉尔",
        "哪怕是自己的一点小小的克制，也会使人变得强而有力。——高尔基",
        "人只有献身于社会，才能找出那短暂而有风险的生命的意义。——爱因斯坦",
        "小时候，幸福——是件很简单的事;长大后，简单——是件很幸福的事。",
        "经验丰富的人读书用两只眼睛，一只眼睛看到纸面上的话，另一眼睛看到纸的背面。——歌德",
        "天才是永恒的耐心。——米开朗琪罗",
        "人们还往往把真理和错误混在一起去教人，而坚持的却是错误。——歌德",
        "对未来的最好策划，是善于处理目前，完成最近的的工作任务。——麦唐纳",
        "伟大变为可笑只有一步，但再走一步，可笑又会变为伟大。——佩思",
        "顺境也好，逆境也好，人生就是一场对种种困难无尽无休的斗争，一场以寡敌众的战斗。——泰戈尔",
        "无论身份高低，只要会消遣就是幸福。——帕斯卡尔",
        "审慎会使人安全，但往往不会幸福。——塞·约翰逊",
        "在一个崇高的目的支持下，不停地工作，即使慢，也一定会获得成功。——爱因斯坦",
        "没有播种，何来收获；没有辛苦，何来成功；没有磨难，何来荣耀；没有挫折，何来辉煌。——佩恩",
        "如果说我看得远，那是正因我站在巨人们的肩上。——牛顿",
        "凡是新的事情在起头总是这样，起初热心的人很多，而不久就冷淡下去，撒手不做了。因为他已经明白，不经过一番苦工是做不成的，而只有想做的人，才忍得过这番痛苦。——陀思妥也夫斯基",
        "青年人任重道远，要继承的不是财产，而是前辈留下的尚未完成的**事业，发扬前辈的**精神。——徐特立",
        "现在的一切都是为将来的梦想编织翅膀，让梦想在现实中展翅高飞。——佚名",
        "一朵成功的花都是由许多苦雨血泥和强烈的暴风雨的环境培养成的。——冼星海",
        "无论什么时候，不管遇到什么状况，我绝不允许自我有一点点灰心丧气。——爱迪生",
        "器大者声必闳，志高者意必远。——范开",
        "卓越的人一大优点是：在不利与艰难的遭遇里百折不饶。——贝多芬",
        "成功=艰苦的劳动+正确的方法+少说空话。——爱因斯坦",
        "只有利害关系和出众的才干，才能帮你出起主意来，才认真细到，眼光透彻。——巴尔扎克",
        "读书忌死读，死读钻牛角，矻矻复孜孜，书我不相属。活读运心智，不为书奴仆，泥沙悉淘汰，所取唯珠玉。——叶圣陶",
        "自由之于人类，就像亮光之于眼睛空气之于肺腑爱情之于心灵。——英格索尔",
        "只有毅力才能使我们成功。而毅力是来源于毫不动摇，坚决采取为达到成功而需要的手段。——车尔尼雪夫斯基",
        "创业要找最合适的人，不一定要找最成功的人！——马云",
        "天地最有情，少年莫浪投。——陈毅",
        "信仰是伟大的情感，一种创造力量。——高尔基",
        "温和、谦逊、多礼的言行，有时能使人回心转意。——萨迪",
        "告诉你使我达到成功的奥秘吧，我惟一的力量就是我的坚持精神。——巴斯德",
        "人生是由短暂的开花期，和长久的花枯萎构成的。——乌兰德",
        "是所有人的朋友，对谁也不是朋友。——波兰",
        "通向人类真正伟大境界的道路只有一条——苦难的道路。——爱因斯坦",
        "一年之计在于春，一日之计在于晨。——萧绛",
        "迁延蹉跎，来日无多，二十丽姝，请来吻我，衰草枯杨，青春易过。——莎士比亚",
        "做了好事受到指责而仍坚持下去，这才是奋斗者的本色。——巴尔扎克",
        "人生诚然有许多烦恼，但在满怀信心，意志坚定的人看来，无难不可摧，乐观努力，就是秘诀。——彭歌",
        "真正的勇敢，都包含谦虚。——吉尔伯特",
        "如果说青春也有缺点，那就是它消逝得太快。——拉洛威尔",
        "幸福就是记忆青春见证时代感恩生活。——白岩松 　　人类幸福的两大敌人是痛苦和无聊。——叔本华",
        "灵感全然不是漂亮地挥着手，而是如健牛般竭尽全力工作的心理状态。——柴可夫斯基",
        "事业是理念和实践的生动统一。——亚里士多德",
        "顺境中不无隐忧和烦恼，逆境中不无慰藉和希望。——培根",
        "惟独革命家，无论他生或死，都能给大家以幸福。——鲁迅",
        "向上看，不要向下看；向前看，不要向后看。——赫尔",
        "有毅力的人，能从磐石里挤出水满。——谚语",
        "不是因为身处何处何种情境，而是因为精神世界，让人或高兴或悲伤。——罗杰·莱斯特兰奇",
        "骄傲的人必然嫉妒，他对于那最以德性受人称赞的人便最怀忌恨。——斯宾诺莎",
        "要成功不需要什么特别的才能，只要把你能做的小事做得好就行了。——维龙",
        "战士是不知道畏缩的。他的脚步很坚定。他看定目标，便一直向前走去。他不怕被绊脚石摔倒，没有一种障碍能使他改变心思。——巴金",
        "什么是天才！我想，天才就是勤奋的结果。——郭沫若",
        "建筑在别人痛苦上的幸福不是真正的幸福。——阿·巴巴耶娃",
        "不戚戚于贫贱，不汲汲于富贵。——陶渊明",
        "书籍是最有耐心最能忍耐和最令人愉快的伙伴。在任何艰难困苦的时刻，它都不会抛弃你。——赫尔岑",
        "开诚布公与否和友情的深浅，不应该用时间的长短来衡量。——巴尔扎克",
        "我们应有恒心，尤其要有自信心！我们必须相信，我们的天赋是要用来做某种事情的。——居里夫人",
        "只要持之以恒，知识丰富了，终能发现其奥秘。——杨振宁",
        "我们世界上最美好的东西，都是由劳动由人的聪明的手创造出来的。——高尔基",
        "对于害怕危险的人，这个世界上总是危险的。——肖伯纳",
        "真正的文明是所有人种植幸福的结果。——幸田露伴",
        "为理想的实现而生活，则生趣盎然。——迪斯里",
        "幸福存在于一个人真正的工作中。——奥理略",
        "无论何人，若是失去了耐心，就失去了灵魂。——培根",
        "盛年不重来，一日难再晨。及时当勉励，岁月不待人。——陶渊明",
        "咬定青山不放松，立根原在破岩中，知磨万击还坚韧，任尔东西南北风。——郑板桥",
        "只有把抱怨环境的心情，化为上进的力量，才是成功的保证。——罗曼·罗兰",
        "无聊是幸福的人的不幸。——沃波尔",
        "人要有毅力，否则将一事无成。——居里夫人",
        "停止奋斗，性命也就停止了。——卡莱尔",
        "一个人如果已经把自己完全投入于权力和仇恨中，你怎么能期望他还有梦？——古龙",
        "老年时最大的安慰莫过于意识到，已把全部青春的力量都献给了永不衰老的事业。——叔本华",
        "重复言说多半是一种时间上的损失。——培根",
        "一两重的真诚，其值等于一吨重的聪明。——德国谚语",
        "做一件好事并不难，难的是养成一种做好事的习惯。——亚里士多德",
        "时间是世界上一切成就的土壤。时间给空想者痛苦，给创造者幸福。——麦金西",
        "一个有事业追求的人，可以把“梦”做得高些。虽然开始时是梦想，但只要不停地做，不轻易放弃，梦想能成真。——虞有澄",
        "有愿望才会幸福。——席勒",
        "人必须相信自己，这是成功的秘诀。——卓别林",
        "人有没有信念并非取决于铁链或任何其他外在压力。——托·卡莱尔",
        "要成大事，就得既有理想，又讲实际，不能走极端。——富兰克林·罗斯福",
        "真正建立共产主义社会的任务正是要由青年担负。——列宁",
        "独有一枝红，秋晚花才放。——吴承恩",
        "只有自己去做，才可能知道能否成功。——林肯",
        "做一个善良的人，为群众谋幸福。——高尔基",
        "一个明智的人总是抓住机遇，把它变成美好的未来。——托·富勒",
        "时间就是能力等等发展的地盘。——马克思",
        "有朋友的人像平原一要宽广，没有朋友的人却像窄狭的手掌。——蒙古族",
        "点燃蜡烛照亮他人者，也不会给自己带来黑暗。——杰弗逊",
        "坚强的信念能赢得强者的心，并使他们变得更坚强。——白哲特",
        "在年轻人的颈项上，没有什么东西比事业心这颗灿烂的宝珠更迷人了。——爱默生",
        "有理想有出息的青年人必定是乐于吃苦的人。——雷锋",
        "锄禾日当午，汗滴禾下土。谁知盘中餐，粒粒皆辛苦！——李绅",
        "许诺固然可以获得友谊，但培养和保持友谊的还是行动。——费尔瑟姆",
        "和平使人民更加幸福，但也使人变得虚弱。",
        "不要轻视失败者的劝告，他在不应该做什么的问题上是权威。——欧洲",
        "随着一种观念的流行，言语创新的程度丝毫不亚于习惯改变的程度——塞·约翰逊",
        "天赋如同自然花木，要用学习来修剪。——培根",
        "不要将过去看成是寂寞的，因为这是再也不会回头的。应想办法改善现在，因为那就是你，毫不畏惧地鼓起勇气向着未来前进。——朗费罗",
        "一个人做事，在动手之前，当然要详慎考虑；但是计划或方针已定之后，就要认定目标前进，不可再有迟疑不决的态度，这就是坚毅的态度。——邹韬奋",
        "巨大的建筑，总是由一木一石叠起来的，我们何妨做这一木一石呢？我时常做些零碎事，就是为此。——鲁迅",
        "真正的爱，在放弃个人的幸福之后才能产生。——列夫·托尔斯泰",
        "梦想是人们与生俱来的重要宝物之一，它等待你的珍视和实践。——邹金宏",
        "正直和诚实还没有发现代用品，人们缺少它就没法取得成功。——布雷默",
        "如烟往事俱忘却，心底无私天地宽。——陶铸",
        "科学是为了那些勤奋好学的人，诗歌是为了那些知识渊博的人。——约瑟夫·鲁",
        "对真理和知识的追求并为之奋斗，是人的最高品质之一。——爱因斯坦",
        "成功并不能用一个人达到什么地位来衡量，而是依据他在迈向成功的过程中，到底克服了多少困难和障碍。——布克·华盛顿",
        "即将来临的一天，比过去的一年更为悠长。——福尔斯特",
        "对生活抱持全面性的好奇，仍是伟大创意人员成功的秘诀。——李奥贝纳",
        "逆境使人发奋向上，要是你从未遭遇过失败，为了事业着想，也许应该经历一次。——莎士比亚",
        "伟大人物的最明显标志，就是他坚强的意志，不管环境变换到何种地步，他的初衷与希望仍不会有丝毫的改变，而终于克服障碍，以达到期望的目的。——爱迪生",
        "灵感，是由于顽强的劳动而获得的奖赏。——列宾",
      ],
    };
  },

  created() {
    var date = new Date();
    date.setDate(date.getDate() - 2);
    this.dates = javaUTCDateToString(date);
    this.loadData();
  },

  computed: {
    ...mapState([
      "user",
      "allDepartments",
      "allShops",
      "allTeams",
      "allUsers",
      "allCategorys",
      "allCategoryHistorys",
      "allShops",
      "userIdToNick",
      "teamIdToName",
      "departmentIdToName",
      "categoryIdToName",
      "categoryIdToInfo",
    ]),

    getSize: function () {
      var size;
      size = "width:" + this.$refs.cardsize.clientWidth + ";" + "height:" + this.$refs.cardsize.clientHeight;
      return size;
    },
  },

  mounted() {
    this.observer = new ResizeObserver(() => {
      // this.$refs.echartPersonalRange.resize();
      // this.$refs.echartD.resize();
      // this.$refs.dataCardChart.resize();
      // this.$refs.pieA.resize();
      // this.$refs.pieB.resize();
      // this.$refs.pieC.resize();
    });
    this.observer.observe(document.querySelector("#mainContainer"));
  },

  beforeDestroy() {
    this.observer.unobserve(document.querySelector("#mainContainer"));
  },

  methods: {
    test() {
      console.log(this.$store.state.user)
    },

    parseDate(date) {
      return javaUTCDateToString(date);
    },
    dayFormat(date) {
      return Number(date.split("-")[2]);
    },

    amountFormat() {
      return amountBeautify(...arguments);
    },

    loadData() {
      var args;
      this.realTotalAmount = 0;
      this.totalAmount = 0;
      this.mainPageCardOrderCount = 0;
      this.mainPageCardActualOrderCount = 0;
      this.totalProfit = 0;
      args = { startDate: this.dates, endDate: this.dates };
      args.startDate = args.startDate.replaceAll("-", "/");
      args.endDate = args.endDate.replaceAll("-", "/");
      this.loadingDialog = true;
      console.log("接口调用", args);
      getProfitReport(args)
        .then((res) => {
          this.loadingDialog = false;
          console.log(res.data);
          if (!res.data.profitReport) {
            this.global.infoAlert("泼发EBC：" + res.data);
            this.profitItems = [];
            return;
          }
          console.log("load");
          this.profitItems = res.data.profitReport;
          this.dataAnalyze();
        })
        .catch(() => {
          this.loading = false;
        });

      getRealTotalAmount({ date: args.startDate })
        .then((res) => {
          this.loadingDialog = false;
          this.realTotalAmount = res.data.amount;
          console.log(res.data);
        })
        .catch(() => {
          this.loading = false;
        });
    },

    dataAnalyze() {
      if (!this.profitItems == []) {
        var personalData = {};
        this.profitItems.forEach((item) => {
          item.calculatedDepartment = this.departmentIdToName[item.department];
          item.calculatedTeam = this.teamIdToName[item.team];
          item.calculatedOwner = this.userIdToNick[item.owner];
          item.calculatedFirstCategory = this.categoryIdToName[item.firstCategory];

          if (item.orderCount == null) {
            item.orderCount = 0;
          }
          if (item.productCount == null) {
            item.productCount = 0;
          }
          if (item.totalAmount == null) {
            item.totalAmount = 0;
          }

          item.deduction /= 100;
          item.freightToPayment /= 100;

          item.calculateTotalAllFakeAmount = item.totalFakeAmount + item.totalPersonalFakeAmount + item.totalPersonalFakeEnablingAmount;

          item.calculatedActualAmount = item.totalAmount - item.calculateTotalAllFakeAmount;
          item.calculatedActualOrderCount = item.orderCount - item.totalFakeCount - item.totalPersonalFakeCount - item.totalPersonalFakeEnablingCount;

          if (item.calculatedActualOrderCount == 0) {
            item.calculatedActualAverageAmount = 0;
          } else {
            item.calculatedActualAverageAmount = item.calculatedActualAmount / item.calculatedActualOrderCount;
          }

          item.calculatedCostRatio = item.totalCost / item.calculatedActualAmount;

          item.calculatedProfitRatio = item.freightToPayment
            ? item.calculatedActualAmount - item.totalCost - item.deduction * item.calculatedActualAmount - item.insurance * item.calculatedActualOrderCount - item.freightToPayment * item.totalCost
            : item.calculatedActualAmount - item.totalCost - item.deduction * item.calculatedActualAmount - (item.insurance + item.freight) * item.calculatedActualOrderCount;
          item.calculatedProfitRatio /= item.calculatedActualAmount;

          item.calculatedActualIncome = item.calculatedActualAmount - item.totalRefundAmount;
          item.calculatedRefundWithNoShipAmount = item.totalRefundWithNoShipAmount * item.calculatedCostRatio;
          //后加的
          if (isNaN(item.calculatedRefundWithNoShipAmount)) {
            item.calculatedRefundWithNoShipAmount = 0;
          }
          //
          item.calculatedActualCost = item.totalCost - item.calculatedRefundWithNoShipAmount;
          item.calculatedTmallTokeRatio = item.deduction * (item.totalAmount - item.totalRefundAmount - item.totalPersonalFakeAmount);
          item.calculatedTotalFreight = item.freightToPayment ? item.freightToPayment * item.calculatedActualCost : item.freight * (item.calculatedActualOrderCount - item.totalRefundWithNoShipCount);
          item.calculatedTotalInsurance = item.insurance * (item.orderCount - item.totalRefundWithNoShipCount);
          item.calculatedActualProfit =
            item.calculatedActualIncome - item.calculatedActualCost - item.calculatedTmallTokeRatio - item.calculatedTotalInsurance - item.calculatedTotalFreight - item.totalBrokerage;

          item.calculatedActualProfitRatio = item.calculatedActualProfit / item.calculatedActualIncome;

          if (item.calculatedActualProfit < 0 && item.calculatedActualProfitRatio > 0) {
            item.calculatedActualProfitRatio *= -1;
          }

          item.calculatedDiscount = item.totalAmount / item.totalPrice;

          if (item.calculatedActualProfit !== item.calculatedActualProfit) {
            item.calculatedActualProfit = 0;
          }

          if (!personalData[item.calculatedOwner]) {
            personalData[item.calculatedOwner] = {
              name: item.calculatedOwner,
              calculatedActualProfit: 0,
              totalAmount: 0,
            };
          }
          personalData[item.calculatedOwner].calculatedActualProfit += item.calculatedActualProfit;
          personalData[item.calculatedOwner].totalAmount += item.totalAmount;

          this.mainPageCardActualOrderCount += item.calculatedActualOrderCount;
          this.mainPageCardOrderCount += item.orderCount;
          this.totalAmount += item.totalAmount;
          this.totalProfit += item.calculatedActualProfit;
        });

        var datas = Object.values(personalData);
        datas.sort((a, b) => {
          return b.calculatedActualProfit - a.calculatedActualProfit;
        });

        this.ratings = datas;
      }
    },
  },
};
</script>

<style scoped></style>