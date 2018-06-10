//
//  displacement.metal
//  TechniqueTest
//
//  Created by Volodymyr Boichentsov on 16/04/2018.
//  Copyright © 2018 3D4Medical LLC. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

struct custom_vertex_t
{
    float4 a_position [[attribute(SCNVertexSemanticPosition)]];
};

constexpr sampler s = sampler(coord::normalized,
                              address::repeat,
                              filter::linear);

struct out_vertex_t
{
    float4 position [[position]];
    float2 uv;
};

vertex out_vertex_t displacementVertex(custom_vertex_t in [[stage_in]],
                                       constant SCNSceneBuffer& scn_frame [[buffer(0)]])
{
    out_vertex_t out;
    out.position = in.a_position;
    out.uv = float2((in.a_position.x + 1.0) * 0.5 , (in.a_position.y + 1.0) * -0.5);
    return out;
};


fragment half4 displacementFragment(out_vertex_t vert [[stage_in]],
                                    texture2d<float, access::sample> colorSampler [[texture(0)]],
                                    texture2d<float, access::sample> noiseSampler [[texture(1)]])
{
    
    float2 displacement = noiseSampler.sample( s, vert.uv).rg - float2(0.5, 0.5);
    float4 FragmentColor = colorSampler.sample(s, vert.uv + displacement * float2(0.1, 0.1));
    
    //    float4 FragmentColor = colorSampler.sample( s, vert.uv) * weight[0];
    //    for (int i=1; i<5; i++) {
    //        FragmentColor += colorSampler.sample( s, ( vert.uv + float2(offset[i], 0.0)/324.0 ) ) * weight[i];
    //        FragmentColor += colorSampler.sample( s, ( vert.uv - float2(offset[i], 0.0)/324.0 ) ) * weight[i];
    //    }
    //    vec2 displacement = texture2D(noiseSampler, uv).rg - vec2(0.5, 0.5);
    //    gl_FragColor = texture2D(colorSampler, uv + displacement * vec2(0.1,0.1));
    
    return half4(FragmentColor);
}
