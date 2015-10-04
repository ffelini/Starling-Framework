/**
 * Created by valera on 01.10.2015.
 */
package starlingExtensions.abstract {
import flash.geom.Matrix;
import flash.geom.Rectangle;

public interface IDisplayObject {

    /**
     * @see starling.display.DisplayObject#x
     */
    function get x():Number;

    /**
     * @private
     */
    function set x(value:Number):void;

    /**
     * @see starling.display.DisplayObject#y
     */
    function get y():Number;

    /**
     * @private
     */
    function set y(value:Number):void;

    /**
     * @see starling.display.DisplayObject#width
     */
    function get width():Number;

    /**
     * @private
     */
    function set width(value:Number):void;

    /**
     * @see starling.display.DisplayObject#height
     */
    function get height():Number;

    /**
     * @private
     */
    function set height(value:Number):void;

    /**
     * @see starling.display.DisplayObject#pivotX
     */
    function get pivotX():Number;

    /**
     * @private
     */
    function set pivotX(value:Number):void;

    /**
     * @see starling.display.DisplayObject#pivotY
     */
    function get pivotY():Number;

    /**
     * @private
     */
    function set pivotY(value:Number):void;

    /**
     * @see starling.display.DisplayObject#scaleX
     */
    function get scaleX():Number;

    /**
     * @private
     */
    function set scaleX(value:Number):void;

    /**
     * @see starling.display.DisplayObject#scaleY
     */
    function get scaleY():Number;

    /**
     * @private
     */
    function set scaleY(value:Number):void;

    /**
     * @see starling.display.DisplayObject#skewX
     */
    function get skewX():Number;

    /**
     * @private
     */
    function set skewX(value:Number):void;

    /**
     * @see starling.display.DisplayObject#skewY
     */
    function get skewY():Number;

    /**
     * @private
     */
    function set skewY(value:Number):void;

    /**
     * @see starling.display.DisplayObject#blendMode
     */
    function get blendMode():String;

    /**
     * @private
     */
    function set blendMode(value:String):void;

    /**
     * @see starling.display.DisplayObject#name
     */
    function get name():String;

    /**
     * @private
     */
    function set name(value:String):void;

    /**
     * @see starling.display.DisplayObject#touchable
     */
    function get touchable():Boolean;

    /**
     * @private
     */
    function set touchable(value:Boolean):void;

    /**
     * @see starling.display.DisplayObject#visible
     */
    function get visible():Boolean;

    /**
     * @private
     */
    function set visible(value:Boolean):void;

    /**
     * @see starling.display.DisplayObject#alpha
     */
    function get alpha():Number;

    /**
     * @private
     */
    function set alpha(value:Number):void;

    /**
     * @see starling.display.DisplayObject#rotation
     */
    function get rotation():Number;

    /**
     * @private
     */
    function set rotation(value:Number):void;

    /**
     * @see starling.display.DisplayObject#parent
     */
    function getParent():IDisplayObjectContainer;

    /**
     * @see starling.display.DisplayObject#hasVisibleArea
     */
    function get hasVisibleArea():Boolean;

    /**
     * @see starling.display.DisplayObject#transformationMatrix
     */
    function get transformationMatrix():Matrix;

    /**
     * @see starling.display.DisplayObject#useHandCursor
     */
    function get useHandCursor():Boolean;

    /**
     * @private
     */
    function set useHandCursor(value:Boolean):void;

    /**
     * @see starling.display.DisplayObject#bounds
     */
    function get bounds():Rectangle;

    /**
     * @see starling.display.DisplayObject#removeFromParent()
     */
    function removeFromParent(dispose:Boolean = false):void;

}
}
