$input a_position, a_texcoord0, a_color0
$output v_color0, v_texcoord0

#include <torque6.sc>

void main()
{
    // Color
    v_color0 = a_color0;

    // Texture
    v_texcoord0 = a_texcoord0;

    // Billboard Projection
    gl_Position = createBillboard(u_model[0], a_position, vec3(0.0, 0.0, 0.0), 1.0);
}
