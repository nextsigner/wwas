/*
Jaunary 2018
This file is created by nextsigner
This code is used for the unik qml engine system too created by nextsigner.
Please read the Readme.md from https://github.com/nextsigner/wwas.git
Contact
    email: nextsigner@gmail.com
    whatsapps: +54 11 3802 4370
*/
import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import QtWebEngine 1.4
ApplicationWindow {
    id:app
    visible: true
    width: 1400
    height: 600
    visibility:"Maximized"
    title: 'WhatsappWeb Audio Speak'
    color: '#333'
    property string moduleName: 'wwas'
    property int fs: app.width*0.02
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"
    property string tool: ""

    property int uAudioIndex: -1
    property string url: 'https://chat.whatsapp.com/KJZca2JtTxU1i0J0Nk0qj9'

    property string colorBarra:'white'

    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    USettings{
        id: unikSettings
        url:pws+'/'+app.moduleName
        Component.onCompleted: {
            currentNumColor=0
            let mc0=defaultColors.split('|')
            let mc1=mc0[currentNumColor].split('-')
            app.c1=mc1[0]
            app.c2=mc1[1]
            app.c3=mc1[2]
            app.c4=mc1[3]
        }
    }
    Row{
        anchors.fill: parent
        Rectangle{
            id: xTools
            width: app.width*0.02
            height: app.height
            color: "#fff"
            z:container.z+99999
            Rectangle{
                width: 1
                height: parent.height
                color: "black"
                anchors.right: parent.right
            }
            Column{
                id: colTools
                width: parent.width
                spacing:  width*0.5
                anchors.verticalCenter: parent.verticalCenter
                Boton{
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: modWhatsapp.url.indexOf(app.url)===0?"\uf167":"\uf0ac"
                    d: modWhatsapp.url==='https://web.whatsapp.com/'?'Ver código fuente de esta app.':'Ir a Whatsapp Web'
                    r:app.fs*0.2
                    onClicking: {
                        modWhatsapp.url=modWhatsapp.url==='https://web.whatsapp.com/'?'https://github.com/nextsigner/wwas':'https://web.whatsapp.com/'
                        //appSettings.red=0;
                    }
                }
                Item{width: parent.width*0.9;height: width}
                Item{width: parent.width*0.9;height: width}
                Boton{
                    id: btnDLV
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: enabled ?1.0:0.5
                    h: w
                    t: "\uf019"
                    d: 'Ver Descargas'
                    r:app.fs*0.2
                    onClicking: {
                        appSettings.dlvVisible = !appSettings.dlvVisible
                    }
                }
                Boton{
                    id: btnUpdate
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: enabled ?1.0:0.5
                    h: w
                    t: "\uf021"
                    d: 'Actualizar esta aplicación'
                    r:app.fs*0.2
                    onClicking: {
                        unik.mkdir(pws+"/wwas")
                        let cmd="-git=https://github.com/nextsigner/wwas.git,-folder="+pws+"/wwas"
                        unik.setUnikStartSettings(cmd)
                        unik.restartApp("")
                    }
                }
                Boton{
                    id: btnApagar
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: enabled ?1.0:0.5
                    h: w
                    t: "\uf011"
                    d: 'Apagar'
                    r:app.fs*0.2
                    onClicking:app.close()
                }
            }
        }
        Rectangle{
            id:container
            width: parent.width
            height: parent.height
            color: '#333'
            ModWebView{
                id:modWhatsapp;
                red:0;
                url:'https://web.whatsapp.com/'
                userAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/73.0.3683.75 Chrome/73.0.3683.75 Safari/537.36"
            }
            LineResizeH{
                id:lineRH;
                y:visible?appSettings.pyLineRH1: parent.height;
                //onLineReleased: appSettings.pyLineRH1 = y;
                visible: modDlv.visible;
                onYChanged: {
                    if(y<container.height/3){
                        y=container.height/3+2
                    }
                }
                Component.onCompleted: {
                    if(lineRH.y<container.height/3){
                        lineRH.y=container.height/3+2
                    }
                }
            }
            ModDLV{
                id: modDlv
                width: parent.width
                anchors.top: lineRH.bottom;
                anchors.bottom: parent.bottom;
                visible: false//appSettings.dlvVisible;
            }
        }
    }
    ULogView{id:uLogView}
    UWarnings{id:uWarnings}
    Timer{
        id:tCheck
        running: true
        repeat: true
        interval: 2000
        onTriggered: {
            //if(modWhatsapp.url==='https://web.whatsapp.com/')return
            modWhatsapp.webEngineView.runJavaScript('document.getElementsByTagName(\'audio\').length', function(result) {
                if(parseInt(result-1)!==app.uAudioIndex){
                    app.uAudioIndex=parseInt(result-1)
                    modWhatsapp.webEngineView.runJavaScript('document.getElementsByTagName(\'audio\')['+app.uAudioIndex+'].play()', function(result2) {
                    });
                }
            });
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Component.onCompleted:  {
        unik.debugLog = true
    }
    function onDLR(download) {
        appSettings.dlvVisible=true
        modDlv.append(download);
        download.accept();
    }
}
