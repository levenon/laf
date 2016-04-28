/**
 * Created by jeri on 2015/12/30.
 */

var itunesUrl = "https://itunes.apple.com/us/app/de-shi/id1073932294?l=zh&ls=1&mt=8";
var apkUrl = "";

//判断访问终端
var browser = {
  versions: function () {
      var u = navigator.userAgent, app = navigator.appVersion;
      return {
          trident: u.indexOf('Trident') > -1, //IE内核
          presto: u.indexOf('Presto') > -1, //opera内核
          webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
          gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1,//火狐内核
          mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
          ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
          android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
          iPhone: u.indexOf('iPhone') > -1, //是否为iPhone或者QQHD浏览器
          iPad: u.indexOf('iPad') > -1, //是否iPad
          webApp: u.indexOf('Safari') == -1, //是否web应该程序，没有头部与底部
          weixin: u.indexOf('MicroMessenger') > -1, //是否微信 （2015-01-22新增）
          qq: u.match(/\sQQ/i) == " qq" //是否QQ
      };
  }(),
  language: (navigator.browserLanguage || navigator.language).toLowerCase()
}

function downloadApplication() {

    //if (browser.versions.android) {
    //    alert("抱歉，请用苹果手机打开")
    //    return;
    //}

    if (browser.versions.mobile && browser.versions.ios) {
        if (browser.versions.weixin) {
            $(".black_overlay").show();
        } else {
            location.href = itunesUrl;
        }
    } else if (browser.versions.mobile && browser.versions.android) {
        if (browser.versions.weixin) {
            $(".black_overlay").show();
        } else {
            location.href = apkUrl;
        }
    } else {
        alert("抱歉，请用手机浏览器打开")
        return;
    }
}

function closeGuide() {
    $(".black_overlay").hide();
}


