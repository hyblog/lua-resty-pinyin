--
-- Created by IntelliJ IDEA.
-- User: hy
-- Date: 18/2/11
-- Time: 下午5:05
-- To change this template use File | Settings | File Templates.
--

local len = string.len
local byte = string.byte
local abs = math.abs
local getn = table.getn
local iconv = require "resty.iconv"
local concat = table.concat

local _M = {
    _VERSION = "1.0.0"
}

local function from_hex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

local function to_hex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c)):lower()
    end))
end

local function to_gbk(str)
    local togbk = iconv:new("gbk", "utf-8")
    return togbk:convert(str)
end

local function search_py(code, codes, dict)
    for i = 1, getn(codes) do
        if codes[i] >= code then
            return dict[concat({ "py", codes[i] }, "_")] or nil
        end
    end
    return nil
end

local function py_codes()
    return {
        10254, 10256, 10260, 10262,
        10270, 10274, 10281, 10296,
        10307, 10309, 10315, 10322,
        10328, 10329, 10331, 10519,
        10533, 10544, 10587, 10764,
        10780, 10790, 10800, 10815,
        10832, 10838, 11014, 11018,
        11019, 11020, 11024, 11038,
        11041, 11045, 11052, 11055,
        11067, 11077, 11097, 11303,
        11324, 11339, 11340, 11358,
        11536, 11589, 11604, 11781,
        11798, 11831, 11847, 11861,
        11867, 12039, 12058, 12067,
        12074, 12089, 12099, 12120,
        12300, 12320, 12346, 12359,
        12556, 12585, 12594, 12597,
        12607, 12802, 12812, 12829,
        12831, 12838, 12849, 12852,
        12858, 12860, 12871, 12875,
        12888, 13060, 13063, 13068,
        13076, 13091, 13095, 13096,
        13107, 13120, 13138, 13147,
        13318, 13326, 13329, 13340,
        13343, 13356, 13359, 13367,
        13383, 13387, 13391, 13395,
        13398, 13400, 13404, 13406,
        13601, 13611, 13658, 13831,
        13847, 13859, 13870, 13878,
        13894, 13896, 13905, 13906,
        13907, 13910, 13914, 13917,
        14083, 14087, 14090, 14092,
        14094, 14097, 14099, 14109,
        14112, 14122, 14123, 14125,
        14135, 14137, 14140, 14145,
        14149, 14151, 14159, 14170,
        14345, 14353, 14355, 14368,
        14379, 14384, 14399, 14407,
        14429, 14594, 14630, 14645,
        14654, 14663, 14668, 14670,
        14674, 14678, 14857, 14871,
        14873, 14882, 14889, 14894,
        14902, 14908, 14914, 14921,
        14922, 14926, 14928, 14929,
        14930, 14933, 14937, 14941,
        15109, 15110, 15117, 15119,
        15121, 15128, 15139, 15140,
        15141, 15143, 15144, 15149,
        15150, 15153, 15158, 15165,
        15180, 15183, 15362, 15363,
        15369, 15375, 15377, 15385,
        15394, 15408, 15416, 15419,
        15435, 15436, 15448, 15454,
        15625, 15631, 15640, 15652,
        15659, 15661, 15667, 15681,
        15701, 15707, 15878, 15889,
        15903, 15915, 15920, 15933,
        15944, 15958, 15959, 16155,
        16158, 16169, 16171, 16180,
        16187, 16202, 16205, 16212,
        16216, 16220, 16393, 16401,
        16403, 16407, 16412, 16419,
        16423, 16427, 16429, 16433,
        16448, 16452, 16459, 16465,
        16470, 16474, 16647, 16657,
        16664, 16689, 16706, 16708,
        16733, 16915, 16942, 16970,
        16983, 17185, 17202, 17417,
        17427, 17433, 17454, 17468,
        17482, 17487, 17496, 17676,
        17683, 17692, 17697, 17701,
        17703, 17721, 17730, 17733,
        17752, 17759, 17922, 17928,
        17931, 17947, 17950, 17961,
        17964, 17970, 17988, 17997,
        18012, 18181, 18183, 18184,
        18201, 18211, 18220, 18231,
        18237, 18239, 18446, 18447,
        18448, 18463, 18478, 18490,
        18501, 18518, 18526, 18696,
        18697, 18710, 18722, 18731,
        18735, 18741, 18756, 18763,
        18773, 18774, 18783, 18952,
        18961, 18977, 18996, 19003,
        19006, 19018, 19023, 19038,
        19212, 19218, 19224, 19227,
        19235, 19238, 19242, 19243,
        19249, 19261, 19263, 19270,
        19275, 19281, 19288, 19289,
        19467, 19479, 19484, 19500,
        19515, 19525, 19531, 19540,
        19715, 19725, 19728, 19739,
        19741, 19746, 19751, 19756,
        19763, 19774, 19775, 19784,
        19805, 19976, 19982, 19986,
        19990, 20002, 20026, 20032,
        20036, 20051, 20230, 20242,
        20257, 20265, 20283, 20292,
        20295, 20304, 20317, 20319
    }
end

local function py_dict()
    return {
        py_10254="zuo", py_10256="zun", py_10260="zui",
        py_10262="zuan", py_10270="zu", py_10274="zou",
        py_10281="zong", py_10296="zi", py_10307="zhuo",
        py_10309="zhun", py_10315="zhui", py_10322="zhuang",
        py_10328="zhuan", py_10329="zhuai", py_10331="zhua",
        py_10519="zhu", py_10533="zhou", py_10544="zhong",
        py_10587="zhi", py_10764="zheng", py_10780="zhen",
        py_10790="zhe", py_10800="zhao", py_10815="zhang",
        py_10832="zhan", py_10838="zhai", py_11014="zha",
        py_11018="zeng", py_11019="zen", py_11020="zei",
        py_11024="ze", py_11038="zao", py_11041="zang",
        py_11045="zan", py_11052="zai", py_11055="za",
        py_11067="yun", py_11077="yue", py_11097="yuan",
        py_11303="yu", py_11324="you", py_11339="yong",
        py_11340="yo", py_11358="ying", py_11536="yin",
        py_11589="yi", py_11604="ye", py_11781="yao",
        py_11798="yang", py_11831="yan", py_11847="ya",
        py_11861="xun", py_11867="xue", py_12039="xuan",
        py_12058="xu", py_12067="xiu", py_12074="xiong",
        py_12089="xing", py_12099="xin", py_12120="xie",
        py_12300="xiao", py_12320="xiang", py_12346="xian",
        py_12359="xia", py_12556="xi", py_12585="wu",
        py_12594="wo", py_12597="weng", py_12607="wen",
        py_12802="wei", py_12812="wang", py_12829="wan",
        py_12831="wai", py_12838="wa", py_12849="tuo",
        py_12852="tun", py_12858="tui", py_12860="tuan",
        py_12871="tu", py_12875="tou", py_12888="tong",
        py_13060="ting", py_13063="tie", py_13068="tiao",
        py_13076="tian", py_13091="ti", py_13095="teng",
        py_13096="te", py_13107="tao", py_13120="tang",
        py_13138="tan", py_13147="tai", py_13318="ta",
        py_13326="suo", py_13329="sun", py_13340="sui",
        py_13343="suan", py_13356="su", py_13359="sou",
        py_13367="song", py_13383="si", py_13387="shuo",
        py_13391="shun", py_13395="shui", py_13398="shuang",
        py_13400="shuan", py_13404="shuai", py_13406="shua",
        py_13601="shu", py_13611="shou", py_13658="shi",
        py_13831="sheng", py_13847="shen", py_13859="she",
        py_13870="shao", py_13878="shang", py_13894="shan",
        py_13896="shai", py_13905="sha", py_13906="seng",
        py_13907="sen", py_13910="se", py_13914="sao",
        py_13917="sang", py_14083="san", py_14087="sai",
        py_14090="sa", py_14092="ruo", py_14094="run",
        py_14097="rui", py_14099="ruan", py_14109="ru",
        py_14112="rou", py_14122="rong", py_14123="ri",
        py_14125="reng", py_14135="ren", py_14137="re",
        py_14140="rao", py_14145="rang", py_14149="ran",
        py_14151="qun", py_14159="que", py_14170="quan",
        py_14345="qu", py_14353="qiu", py_14355="qiong",
        py_14368="qing", py_14379="qin", py_14384="qie",
        py_14399="qiao", py_14407="qiang", py_14429="qian",
        py_14594="qia", py_14630="qi", py_14645="pu",
        py_14654="po", py_14663="ping", py_14668="pin",
        py_14670="pie", py_14674="piao", py_14678="pian",
        py_14857="pi", py_14871="peng", py_14873="pen",
        py_14882="pei", py_14889="pao", py_14894="pang",
        py_14902="pan", py_14908="pai", py_14914="pa",
        py_14921="ou", py_14922="o", py_14926="nuo",
        py_14928="nue", py_14929="nuan", py_14930="nv",
        py_14933="nu", py_14937="nong", py_14941="niu",
        py_15109="ning", py_15110="nin", py_15117="nie",
        py_15119="niao", py_15121="niang", py_15128="nian",
        py_15139="ni", py_15140="neng", py_15141="nen",
        py_15143="nei", py_15144="ne", py_15149="nao",
        py_15150="nang", py_15153="nan", py_15158="nai",
        py_15165="na", py_15180="mu", py_15183="mou",
        py_15362="mo", py_15363="miu", py_15369="ming",
        py_15375="min", py_15377="mie", py_15385="miao",
        py_15394="mian", py_15408="mi", py_15416="meng",
        py_15419="men", py_15435="mei", py_15436="me",
        py_15448="mao", py_15454="mang", py_15625="man",
        py_15631="mai", py_15640="ma", py_15652="luo",
        py_15659="lun", py_15661="lue", py_15667="luan",
        py_15681="lv", py_15701="lu", py_15707="lou",
        py_15878="long", py_15889="liu", py_15903="ling",
        py_15915="lin", py_15920="lie", py_15933="liao",
        py_15944="liang", py_15958="lian", py_15959="lia",
        py_16155="li", py_16158="leng", py_16169="lei",
        py_16171="le", py_16180="lao", py_16187="lang",
        py_16202="lan", py_16205="lai", py_16212="la",
        py_16216="kuo", py_16220="kun", py_16393="kui",
        py_16401="kuang", py_16403="kuan", py_16407="kuai",
        py_16412="kua", py_16419="ku", py_16423="kou",
        py_16427="kong", py_16429="keng", py_16433="ken",
        py_16448="ke", py_16452="kao", py_16459="kang",
        py_16465="kan", py_16470="kai", py_16474="ka",
        py_16647="jun", py_16657="jue", py_16664="juan",
        py_16689="ju", py_16706="jiu", py_16708="jiong",
        py_16733="jing", py_16915="jin", py_16942="jie",
        py_16970="jiao", py_16983="jiang", py_17185="jian",
        py_17202="jia", py_17417="ji", py_17427="huo",
        py_17433="hun", py_17454="hui", py_17468="huang",
        py_17482="huan", py_17487="huai", py_17496="hua",
        py_17676="hu", py_17683="hou", py_17692="hong",
        py_17697="heng", py_17701="hen", py_17703="hei",
        py_17721="he", py_17730="hao", py_17733="hang",
        py_17752="han", py_17759="hai", py_17922="ha",
        py_17928="guo", py_17931="gun", py_17947="gui",
        py_17950="guang", py_17961="guan", py_17964="guai",
        py_17970="gua", py_17988="gu", py_17997="gou",
        py_18012="gong", py_18181="geng", py_18183="gen",
        py_18184="gei", py_18201="ge", py_18211="gao",
        py_18220="gang", py_18231="gan", py_18237="gai",
        py_18239="ga", py_18446="fu", py_18447="fou",
        py_18448="fo", py_18463="feng", py_18478="fen",
        py_18490="fei", py_18501="fang", py_18518="fan",
        py_18526="fa", py_18696="er", py_18697="en",
        py_18710="e", py_18722="duo", py_18731="dun",
        py_18735="dui", py_18741="duan", py_18756="du",
        py_18763="dou", py_18773="dong", py_18774="diu",
        py_18783="ding", py_18952="die", py_18961="diao",
        py_18977="dian", py_18996="di", py_19003="deng",
        py_19006="de", py_19018="dao", py_19023="dang",
        py_19038="dan", py_19212="dai", py_19218="da",
        py_19224="cuo", py_19227="cun", py_19235="cui",
        py_19238="cuan", py_19242="cu", py_19243="cou",
        py_19249="cong", py_19261="ci", py_19263="chuo",
        py_19270="chun", py_19275="chui", py_19281="chuang",
        py_19288="chuan", py_19289="chuai", py_19467="chu",
        py_19479="chou", py_19484="chong", py_19500="chi",
        py_19515="cheng", py_19525="chen", py_19531="che",
        py_19540="chao", py_19715="chang", py_19725="chan",
        py_19728="chai", py_19739="cha", py_19741="ceng",
        py_19746="ce", py_19751="cao", py_19756="cang",
        py_19763="can", py_19774="cai", py_19775="ca",
        py_19784="bu", py_19805="bo", py_19976="bing",
        py_19982="bin", py_19986="bie", py_19990="biao",
        py_20002="bian", py_20026="bi", py_20032="beng",
        py_20036="ben", py_20051="bei", py_20230="bao",
        py_20242="bang", py_20257="ban", py_20265="bai",
        py_20283="ba", py_20292="ao", py_20295="ang",
        py_20304="an", py_20317="ai", py_20319="a"
    }
end

local function to_py(str)
    local ret = ""
    local hex = to_hex(str)
    local length = len(hex)
    local codes = py_codes()
    local dict = py_dict()
    local ii = 1
    for i = 1, length do
        if ii >= length then
            return ret
        end
        local tmp_lcode = hex:sub(ii, ii+1)
        local lcode = byte(from_hex(tmp_lcode))
        if lcode > 128 then
            local tmp_rcode = hex:sub(ii+2, ii+3)
            local rcode = byte(from_hex(tmp_rcode))

            local code = 65536 - lcode * 256 - rcode
            local res, err = search_py(code, codes, dict)
            if not not res then
                ret = concat({ ret, res })
            end
            ii = ii+4
        else
            ret = concat({ ret, from_hex(tmp_lcode) })
            ii = ii+2
        end
    end
    return ret
end

function _M.convert(param)
    local str, err = to_gbk(param)
    if not str then
        return param, err
    end
    return to_py(str)
end

return _M