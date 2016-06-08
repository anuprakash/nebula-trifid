//------------------------------------------------------------------------------
//  averagelum.fx
//  (C) 2013 Gustav Sterbrant
//------------------------------------------------------------------------------

#include "lib/std.fxh"
#include "lib/techniques.fxh"
#include "lib/util.fxh"

sampler2D ColorSource;
sampler2D PreviousLum;

samplerstate LuminanceSampler
{
	Samplers = { ColorSource, PreviousLum };
	Filter = Point;
};

float TimeDiff;

state AverageLumState
{
	CullMode = Back;
	DepthEnabled = false;
	DepthWrite = false;
};


//------------------------------------------------------------------------------
/**
*/
shader
void
vsMain(in vec3 position,
	[slot=2] in vec2 uv,
	out vec2 UV) 
{
	gl_Position = vec4(position, 1);
	UV = uv;
}

//------------------------------------------------------------------------------
/**
*/
shader
void
psMain(vec2 UV, [color0] out float result)
{
	vec2 pixelSize = GetPixelSize(ColorSource);

	// source should be a 512x512 texture, so we sample the 8'th mip of the texture
	vec4 sample1 = texelFetch(ColorSource, ivec2(1, 0), 8);
	vec4 sample2 = texelFetch(ColorSource, ivec2(0, 1), 8);
	vec4 sample3 = texelFetch(ColorSource, ivec2(1, 1), 8);
	vec4 sample4 = texelFetch(ColorSource, ivec2(0, 0), 8);
	float currentLum = dot((sample1 + sample2 + sample3 + sample4) * 0.25f, vec4(0.2126f, 0.7152f, 0.0722f, 0));
	float lastLum = texelFetch(PreviousLum, ivec2(0, 0), 0).r;

	float lum = lastLum + clamp(currentLum - lastLum,-1.0f,1.0f) * (1.0 - pow(0.98, 30.0 * TimeDiff));
	lum = clamp(lum, 0.25f, 5.0f);
	result = lum;
}

//------------------------------------------------------------------------------
/**
*/
PostEffect(vsMain(), psMain(), AverageLumState);
