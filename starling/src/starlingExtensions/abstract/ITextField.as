/**
 * Created by valera on 03.10.2015.
 */
package starlingExtensions.abstract {
public interface ITextField extends IDisplayObject {
    function get text():String;

    function set text(value:String):void;

    function get fontName():String;

    function set fontName(value:String):void;

    function get bold():Boolean;

    function set bold(value:Boolean):void;

    function get vAlign():String;

    function set vAlign(value:String):void;

    function get hAlign():String;

    function set hAlign(value:String):void;

    function get color():uint;

    function set color(value:uint):void;

    function get fontSize():Number;

    function set fontSize(value:Number):void;

    function get autoScale():Boolean;

    function set autoScale(value:Boolean):void;
}
}
