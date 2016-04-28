

function loadImages() {

	var imageParameters = "&scale=!" + document.body.clientWidth
			+ "x450r&crop=" + document.body.clientWidth + "x450";
	var childs = document.getElementById('imageContent').childNodes;
	for ( var i = 0; i < childs.length; i++) {

		var imageElement = childs[i];
		imageElement.src = imageElement.defaultUrl + imageParameters;
	}
};

//判断访问终端
var browser = {
  versions: function () {
      var u = navigator.userAgent;
//      var app = navigator.appVersion;
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
};

$(function () {
//	fixScreenSize();
});

function fixScreenSize() {
	
    if (browser.versions.android || browser.versions.mobile || browser.versions.ios) {

		var phoneWidth =  parseInt(window.screen.width);
		var phoneScale = phoneWidth/640;
	    
	    var head = document.head || document.getElementsByTagName('head')[0];
	    var meta = document.createElement('meta');
	
	    meta.name = "viewport";
	    meta.content = "\"width=640, minimum-scale = "+ phoneScale +", maximum-scale = "+ phoneScale +", target-densitydpi=device-dpi>\"";
	    
	    head.appendChild(meta);

    }

}
