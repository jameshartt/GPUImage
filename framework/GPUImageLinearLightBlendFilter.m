#import "GPUImageLinearLightBlendFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageLinearLightBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     
     //Linear Light
     //vec3 linearLight (vec3 target, vec3 blend){
     //   vec3 temp;
     //   temp.x = (blend.x > 0.5) ? (target.x)+(2.0*(blend.x-0.5)) : (target.x +(2.0*blend.x-1.0));
     //   temp.y = (blend.y > 0.5) ? (target.y)+(2.0*(blend.y-0.5)) : (target.y +(2.0*blend.y-1.0));
     //   temp.z = (blend.z > 0.5) ? (target.z)+(2.0*(blend.z-0.5)) : (target.z +(2.0*blend.z-1.0));
     //   return temp;
     //}
     
     //blend is overlay, target is base
     
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     highp float ra;
     highp float ga;
     highp float ba;
     //remove the alpha HERE below before the 0.5 if funny
     ra = (base.r > 0.5) ? (overlay.r * overlay.a) + (2.0 * (base.r * base.a - 0.5)) : (overlay.r * overlay.a + (2.0 * base.r * base.a - 1.0));
     ga = (base.g > 0.5) ? (overlay.g * overlay.a) + (2.0 * (base.g * base.a - 0.5)) : (overlay.g * overlay.a + (2.0 * base.g * base.a - 1.0));
     ba = (base.b > 0.5) ? (overlay.b * overlay.a) + (2.0 * (base.b * base.a - 0.5)) : (overlay.b * overlay.a + (2.0 * base.b * base.a - 1.0));
     /*     if (dot(overlay.rgb * overlay.a, W) < 0.5) {
      ra = base.r * base.a + (2.0 * overlay.r * overlay.a - 1.0);
      ga = base.g * base.a + (2.0 * overlay.g * overlay.a - 1.0);
      ba = base.b * base.a + (2.0 * overlay.b * overlay.a - 1.0);
      } else {
      ra = base.r * base.a + 2.0 * (overlay.r * overlay.a - 0.5);
      ga = base.g * base.a + 2.0 * (overlay.g * overlay.a - 0.5);
      ba = base.b * base.a + 2.0 * (overlay.b * overlay.a - 0.5);
      }*/
     
     gl_FragColor = vec4(ra, ga, ba, 1.0);
 }
 );
#else
NSString *const kGPUImageLinearLightBlendFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 const vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     vec4 base = texture2D(inputImageTexture, textureCoordinate);
     vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     float ra;
     float ga;
     float ba;
     ra = (base.r > 0.5) ? (overlay.r * overlay.a) + (2.0 * (base.r * base.a - 0.5)) : (overlay.r * overlay.a + (2.0 * base.r * base.a - 1.0));
     ga = (base.g > 0.5) ? (overlay.g * overlay.a) + (2.0 * (base.g * base.a - 0.5)) : (overlay.g * overlay.a + (2.0 * base.g * base.a - 1.0));
     ba = (base.b > 0.5) ? (overlay.b * overlay.a) + (2.0 * (base.b * base.a - 0.5)) : (overlay.b * overlay.a + (2.0 * base.b * base.a - 1.0));
     
     gl_FragColor = vec4(ra, ga, ba, 1.0);
 }
 );
#endif


@implementation GPUImageLinearLightBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageLinearLightBlendFragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end

