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
    width: 1280
    height: 500
    //x:0
    //y:0
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

    property int uAudioIndex: 0
    property int statePlaying: 0
    property string url: 'https://chat.whatsapp.com/KJZca2JtTxU1i0J0Nk0qj9'

    property string colorBarra:'white'

    property var audioDurs: []
    property var audioDursPlayed: []
    property real uDurPlaying

    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    USettings{
        id: unikSettings
        url: app.moduleName
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
                //zoomFactor: 0.5
                visible: false//appSettings.dlvVisible;
            }
        }
    }
    ULogView{id:uLogView}
    UWarnings{id:uWarnings}
    Timer{
        //id:tCheck
        running: true
        repeat: true
        interval: 6000
        onTriggered: {
            if(!tCheck.running){
                //tCheck.interval=3000
                tCheck.start()
            }
        }
    }
    Timer{
        id:tResetAudioIndexPlaying
        running: false
        repeat: false
        interval: 1000000
        onTriggered: {
            app.statePlaying=0
        }
    }

    Timer{
        id:tCheckUCant
        running: true
        repeat: true
        interval: 500
        onTriggered: {
            modWhatsapp.webEngineView.runJavaScript('document.getElementsByTagName(\'audio\').length', function(result) {
                if(app.uCant!==result){
                    app.cantDif=true
                    app.statePlaying=result-1
                }else{
                    app.cantDif=false
                }
                if(app.uCant>result){
                    app.uAudioIndex=0
                }
                app.uCant=result
                app.audioDurs=[]
                for(var i=0;i<result;i++){
                    modWhatsapp.webEngineView.runJavaScript('document.getElementsByTagName(\'audio\')['+i+'].duration', function(result2) {
                        app.audioDurs.push(result2)
                    });
                }
            });
        }
    }
    property int uCant: 0
    property bool cantDif: false
    Timer{
        id:tCheck
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            if(app.statePlaying===1){
                console.log('app.statePlaying='+app.statePlaying)
                return
            }
            var indexToPlay=app.uCant-1
            if(app.uCant-1>app.uAudioIndex){
                indexToPlay=app.audioDurs.indexOf(app.uDurPlaying)+1
            }
            //info.text+=' rep: '+indexToPlay+'\n'
            modWhatsapp.webEngineView.runJavaScript('document.getElementsByTagName(\'audio\')['+indexToPlay+'].duration', function(resultDur) {
                if(resultDur!==app.uDurPlaying){
                    tResetAudioIndexPlaying.stop()
                    tResetAudioIndexPlaying.interval=parseInt(resultDur * 1000)+2000
                    tResetAudioIndexPlaying.start()
                    app.uDurPlaying=resultDur
                    app.statePlaying=1
                    modWhatsapp.webEngineView.runJavaScript('document.getElementsByTagName(\'audio\')['+indexToPlay+'].play()', function(result2) {
                        app.audioDursPlayed.push(resultDur)
                        app.uAudioIndex=indexToPlay
                    });
                }
            });
        }
    }
//    Text {
//        id: info
//        font.pixelSize: 30
//        color: 'red'
//        width: app.width*0.8
//        wrapMode: Text.WordWrap
//        z: modWhatsapp.z+100000
//    }
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
