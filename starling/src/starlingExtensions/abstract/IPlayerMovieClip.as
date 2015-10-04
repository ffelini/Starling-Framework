/**
 * Created by valera on 03.10.2015.
 */
package starlingExtensions.abstract {
public interface IPlayerMovieClip {
    function get currentFrame():int;

    function set currentFrame(value:int):void;

    function set fps(value:Number):void;

    function get fps():Number;
}
}
