//-----------------------------------------------------------------------------
// Copyright (c) 2015 Andrew Mac
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//-----------------------------------------------------------------------------

#ifndef _PLUGINS_SHARED_H
#include <plugins/plugins_shared.h>
#endif

#ifndef _SIM_OBJECT_H_
#include <sim/simObject.h>
#endif

#ifndef _BASE_COMPONENT_H_
#include <scene/components/baseComponent.h>
#endif

#ifndef _RENDER_CAMERA_H_
#include "rendering/renderCamera.h"
#endif

class ScatterSkyComponent : public Scene::BaseComponent, public Rendering::RenderHook
{
   private:
      typedef Scene::BaseComponent Parent;

   protected:
      bool                       mEnabled;
      bgfx::TextureHandle        mTexture;
      bgfx::ProgramHandle        mShader;
      bgfx::UniformHandle        mMatrixUniform;
      Graphics::ViewTableEntry*  mView;
		bool								mGenerateSkyCube;
		bool								mSkyCubeReady;
		bgfx::ProgramHandle        mGenerateSkyCubeShader;
      bgfx::UniformHandle        mCubeParamsUniform;
      bgfx::UniformHandle        mSkyParams1Uniform;
      bgfx::UniformHandle        mSkyParams2Uniform;
      bgfx::UniformHandle        mSkyParams3Uniform;
      bgfx::UniformHandle        mSkyParams4Uniform;
      bgfx::UniformHandle        mSkyParams5Uniform;

      F32                        mIntensity;
      F32                        mSunBrightness;
      F32                        mSurfaceHeight;
      F32                        mScatterStrength;
      F32                        mMieBrightness;
      F32                        mMieDistribution;
      F32                        mMieCollectionPower;
      F32                        mMieStrength;
      F32                        mRayleighBrightness;
      F32                        mRayleighCollectionPower;
      F32                        mRayleighStrength;
      F32                        mStepCount;
      ColorF                     mAirColor;

      Graphics::ViewTableEntry*  mTempSkyCubeView[6];
      bgfx::FrameBufferHandle    mTempSkyCubeBuffers[6];

   public:
		ScatterSkyComponent();
      ~ScatterSkyComponent();

      virtual void onAddToScene();
      virtual void onRemoveFromScene();
      virtual void refresh();

      virtual void preRender(Rendering::RenderCamera* camera);
      virtual void render(Rendering::RenderCamera* camera);
      virtual void postRender(Rendering::RenderCamera* camera);
		
      void generateSkyCubeBegin();
		void generateSkyCube();
      void generateSkyCubeEnd();

      static void initPersistFields();

      DECLARE_PLUGIN_CONOBJECT(ScatterSkyComponent);
};