package utils {
import flash.display.Stage;
import flash.events.ErrorEvent;
import flash.events.UncaughtErrorEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

public class LogCat extends TextField {
    private var _stage:Stage;

    public function LogCat(_stage:Stage, _backgroundColor:uint=0x999999) {
        super();
        if (_stage != null) {
            this._stage = _stage;

            type = TextFieldType.DYNAMIC;
            background = true;
            backgroundColor = _backgroundColor;
            width = _stage.width;
            height = _stage.height;
            multiline = true;
            selectable = true;
            autoSize = TextFieldAutoSize.LEFT;

            defaultTextFormat = new TextFormat("Arial", 16, 0x000000, true);
            _stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
        }
    }

    private function onUncaughtError(e:UncaughtErrorEvent):void {
        var errorMessage:String = '[ UNCAUGHT ERROR ] :: ';
        if (e.error is Error) {
            var error:Error = e.error as Error;
            errorMessage += error.errorID + ' :: ' + error.message + '\n' + error.getStackTrace();
        }
        else if (e.error is ErrorEvent) {
            var errorEvent:ErrorEvent = e.error as ErrorEvent;
            errorMessage += errorEvent.errorID + ' :: ' + errorEvent.toString();
        }
        else {
            /*
             * THIS MEANS SOMEONE DID SOMETHING LIKE:
             *     throw mySprite;
             * ...GO FIGURE...
             */
            errorMessage += 'A non-Error, non-ErrorEvent type was thrown and uncaught!'
        }

        appendText(errorMessage + '\n\n');
        if(_stage!=null) {
            _stage.addChild(this);
        }
    }
}
}