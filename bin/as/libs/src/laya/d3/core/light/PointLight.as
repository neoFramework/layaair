package laya.d3.core.light {
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.utils.Stat;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * <code>PointLight</code> 类用于创建点光。
	 */
	public class PointLight extends LightSprite {
		/** @private */
		private var _attenuation:Vector3;
		/** @private */
		private var _range:Number;
		
		/**
		 * 创建一个 <code>PointLight</code> 实例。
		 */
		public function PointLight() {
			super();
			
			_diffuseColor = new Vector3(1.0, 1.0, 1.0);
			_ambientColor = new Vector3(0.2, 0.2, 0.2);
			_specularColor = new Vector3(1.0, 0.0, 0.0);
			_reflectColor = new Vector3(1.0, 1.0, 1.0);
			
			transform.position = new Vector3(0.0, 0.0, 0.0);
			_range = 6.0;
			_attenuation = new Vector3(0.6, 0.6, 0.6);
		}
		
		/**
		 * 获取点光的范围。
		 * @return 点光的范围。
		 */
		public function get range():Number {
			return _range;
		}
		
		/**
		 * 设置点光的范围。
		 * @param  value 点光的范围。
		 */
		public function set range(value:Number):void {
			_range = value;
		}
		
		/**
		 * 获取点光的衰减。
		 * @return 点光的衰减。
		 */
		public function get attenuation():Vector3 {
			return _attenuation;
		}
		
		/**
		 * 设置点光的衰减。
		 * @param value 点光的衰减。
		 */
		public function set attenuation(value:Vector3):void {
			_attenuation = value;
		}
		
		/**
		 * 获取点光的类型。
		 * @return 点光的类型。
		 */
		public override function get lightType():int {
			return TYPE_POINTLIGHT;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _clearSelfRenderObjects():void {
			var scene:Scene = this.scene;
			var shaderValue:ValusArray = scene._shaderValues;
			shaderValue.setValue(Scene.POINTLIGHTDIFFUSE, null);
			shaderValue.setValue(Scene.POINTLIGHTAMBIENT, null);
			shaderValue.setValue(Scene.POINTLIGHTSPECULAR, null);
			shaderValue.setValue(Scene.POINTLIGHTPOS, null);
			shaderValue.setValue(Scene.POINTLIGHTRANGE, null);
			shaderValue.setValue(Scene.POINTLIGHTATTENUATION, null);
			scene.removeShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT);
		}
		
		/**
		 * 更新点光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function updateToWorldState(state:RenderState):Boolean {
			var scene:Scene = state.scene;
			if (scene.enableLight && _activeInHierarchy) {
				var shaderValue:ValusArray = scene._shaderValues;
				scene.addShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT);
				shaderValue.setValue(Scene.POINTLIGHTDIFFUSE, diffuseColor.elements);
				shaderValue.setValue(Scene.POINTLIGHTAMBIENT, ambientColor.elements);
				shaderValue.setValue(Scene.POINTLIGHTSPECULAR, specularColor.elements);
				
				shaderValue.setValue(Scene.POINTLIGHTPOS, transform.position.elements);
				shaderValue.setValue(Scene.POINTLIGHTRANGE, range);
				shaderValue.setValue(Scene.POINTLIGHTATTENUATION, attenuation.elements);
				return true;
			} else {
				scene.removeShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT);
				return false;
			}
		}
	
	}

}