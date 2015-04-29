$input a_position, a_texcoord0, i_data0, i_data1
$output v_position, v_texcoord0, v_color0

#include <torque6.sc>
void main()
{
    v_position = vec4(a_position, 1.0);

    // Standard: UV Coordinates
    v_texcoord0 = a_texcoord0;

    // Particle Color
    v_color0 = i_data1;

    // Billboard Projection
    gl_Position = createBillboard(u_model[0], a_position, i_data0.xyz, 10.0);
}
