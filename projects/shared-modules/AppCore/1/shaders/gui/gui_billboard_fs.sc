$input v_color0, v_texcoord0
#include <torque6.sc>

SAMPLER2D(Texture0, 0);

void main()
{
    vec4 color = texture2D(Texture0, v_texcoord0);
    color *= v_color0;
    clip( color.a < 0.5 ? -1.0 : 1.0 );

    gl_FragColor = encodeRGBE8(color.rgb);
}
