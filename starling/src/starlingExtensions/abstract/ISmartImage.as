/**
 * Created by valera on 03.10.2015.
 */
package starlingExtensions.abstract {
public interface ISmartImage extends IQuad {
    function set topColor(c:uint):void;

    function get topColor():uint;

    function set bottomColor(c:uint):void;

    function get bottomColor():uint;

    function set leftColor(c:uint):void;

    function get leftColor():uint;

    function set rightColor(c:uint):void;

    function get rightColor():uint;

    function set topAlpha(c:Number):void;

    function get topAlpha():Number;

    function set bottomAlpha(c:Number):void;

    function get bottomAlpha():Number;

    function set leftAlpha(c:Number):void;

    function get leftAlpha():Number;

    function set rightAlpha(c:Number):void;

    function get rightAlpha():Number;
}
}
