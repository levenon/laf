
// Per window code to get current selection
document.addEventListener("contextmenu", contextMenu, false);

function contextMenu(event) {
    var ui = { date: new Date(),
               curpage: document.URL, 
               title: document.title
             };

    var el = document.elementFromPoint(event.clientX, event.clientY);
    if(el != null) {
        if(el.tagName != 'A' && el.parentElement != null)
            el = el.parentElement;

        if(el.tagName == 'A' && el.href != '') {
            ui.name = (el.textContent.length <= 1) ? el.href : el.textContent;
            ui.href = el.href;
        }
    }

   if(ui.href === undefined) {
        var sel = window.parent.getSelection().toString();
        sel = sel.replace(/^\s+|\s+$/g, '');

        // TODO: Add in better url detection        
        if(sel.match(/^(https?:\/\/|www\.)(\S+)$/)) {
            ui.name = sel;
            if(sel.match(/^https?:\/\//))
                ui.href = sel;
            else 
               ui.href = 'http://' + sel;
        }
    }
    safari.self.tab.setContextMenuEventUserInfo(event, ui);
}
