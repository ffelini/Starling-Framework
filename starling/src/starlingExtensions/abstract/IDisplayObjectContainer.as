/**
 * Created by valera on 01.10.2015.
 */
package starlingExtensions.abstract {
public interface IDisplayObjectContainer extends IDisplayObject {
    function addAChild(child:IDisplayObject):void;

    function addAChildAt(child:IDisplayObject, index:int):void;

    function getAChildAt(index:int):IDisplayObject;

    function getAChildIndex(child:IDisplayObject):int;

    function removeAChild(child:IDisplayObject):void;

    function removeAChildAt(index:int, child:IDisplayObject):void;

    function get numChildren():int;
}
}
