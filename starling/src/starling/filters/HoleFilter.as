package starling.filters
{
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;

import starling.textures.Texture;

/**
	 * Не затемнения для - туториалов ради
	 *  
	 * @author Parvan Eugeniu
	 * 
	 */	
	public class HoleFilter extends FragmentFilter
	{
		private var mQuantifiers:Vector.<Number> = new <Number>[1, 1, 1, 1];
		private var mRadius:Vector.<Number> = new <Number>[1, 1, 1, 1];
		private var cx:Number;
		private var cy:Number;
		private var radius:Number;
		private var mShaderProgram:Program3D;
		
		/**
		 * 
		 * @param cx
		 * @param cy
		 * @param radius
		 * 
		 */		
		public function HoleFilter(cx:Number, cy:Number, radius:Number)
		{
			this.cx = cx;
			this.cy = cy;
			this.radius = radius;
		}
		
		public override function dispose():void
		{
			if (mShaderProgram) mShaderProgram.dispose();
			super.dispose();
		}
		
		protected override function createPrograms():void
		{
			var fragmentProgramCode:String =
				"sub ft0.x, v0.x, 	fc0.x							\n" +
				"mul ft0.x, ft0.x, 	fc0.z							\n" +
				"mul ft0.x, ft0.x, 	ft0.x							\n" +
				
				
				"sub ft0.y, v0.y, 	fc0.y							\n" +
				"mul ft0.y, ft0.y, 	fc0.w							\n" +
				"mul ft0.y, ft0.y, 	ft0.y							\n" +
				
				"add ft0.z, ft0.x, 	ft0.y							\n" +
				"sqt ft0.x, ft0.z									\n" +
				"tex ft1, 	v0, 	fs0<2d, clamp, linear, mipnone>	\n" +
				"sge ft0.w, ft0.x, 	fc1.x							\n" +
				"mul ft1, ft1, 	ft0.w							\n" +
				"mov oc, 	ft1"
			
			mShaderProgram = assembleAgal(fragmentProgramCode);
		}
		
		protected override function activate(pass:int, context:Context3D, texture:Texture):void
		{
			mQuantifiers[0] = cx /  texture.width;
			mQuantifiers[1] = cy /  texture.height;
			mQuantifiers[2] = texture.width;
			mQuantifiers[3] = texture.height;
			mRadius[0] = radius;
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mQuantifiers, 1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mRadius, 1);
			context.setProgram(mShaderProgram);
		}
	}
}