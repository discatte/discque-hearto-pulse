//# TODO penguins wearing disk costumes dancing on a disco light up floor


// POV-Ray 3.7 Scene File " ... .pov"
// author:  Discatte (@galacticfurball)
// date:    Feb 18, 2021
//--------------------------------------------------------------------------
#version 3.7;
global_settings{ assumed_gamma 1.0 }
#default{ finish{ ambient 0.1 diffuse 0.9 }} 
//--------------------------------------------------------------------------
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "metals.inc"
#include "golds.inc"
#include "stones.inc"
#include "woods.inc"
#include "shapes.inc"
#include "shapes2.inc"
#include "functions.inc"
#include "math.inc"
#include "transforms.inc"


// MATH


#declare B1 = function(h) { h*h*h }
#declare B2 = function(h) { 3*h*h*(1-h) }
#declare B3 = function(h) { 3*h*(1-h)*(1-h) }
#declare B4 = function(h) { (1-h)*(1-h)*(1-h) }
  
#macro CubicBezierEase(p, x2, y2, x3, y3)
 #local x1 = 0;
 #local y1 = 0;
 #local x4 = 1;
 #local y4 = 1;
 #local cx = x1*B1(p) + x2*B2(p) + x3*B3(p) + x4*B4(p);
 #local cy = y1*B1(p) + y2*B2(p) + y3*B3(p) + y4*B4(p);
 <cx,cy,0>
#end //CubicBezierEase

#macro CubicBezierEase1D(p, x2, y2, x3, y3)
 #local x1 = 0;
 #local y1 = 0;
 #local x4 = 1;
 #local y4 = 1;
 //#local cx = x1*B1(p) + x2*B2(p) + x3*B3(p) + x4*B4(p);
 #local cy = y1*B1(p) + y2*B2(p) + y3*B3(p) + y4*B4(p);
 cy
#end 


//--------------------------------------------------------------------------
// camera ------------------------------------------------------------------
#declare Camera_0 = camera {perspective angle 75               // front view
                            location  <0.0 , 5.0 ,-10.0>
                            right     x*image_width/image_height
                            look_at   <0.0 , -1.0 , 0.0>}

camera{Camera_0}
// sun ----------------------------------------------------------------------
light_source{< 3000,3000,-3000> color White*0.0}

// sky ----------------------------------------------------------------------
#declare Skymult = 0.5;
sky_sphere { pigment { gradient <0,1,0>
                       color_map { [0.00 rgb <0.6,0.7,1.0>*Skymult]
                                   [0.35 rgb <0.1,0.0,0.8>*Skymult]
                                   [0.65 rgb <0.1,0.0,0.8>*Skymult]
                                   [1.00 rgb <0.6,0.7,1.0>*Skymult] 
                                 } 
                       scale 2         
                     } // end of pigment
           } //end of skysphere

// ground -------------------------------------------------------------------
plane{ <0,1,0>, 0 
       texture{ pigment{ checker color rgb<1,1,1>*1.2 color rgb<0.25,0.15,0.1>*0}
              //normal { bumps 0.75 scale 0.025}
                finish { phong 0.1}
              } // end of texture
     } // end of plane


// Shape Driver

#declare DriverHeart =
 array[15][15]
 {
   {000,017,025,025,025,025,017,000,017,025,025,025,025,017,000},
   {017,025,051,051,051,051,025,017,025,051,051,051,051,025,017},
   {025,051,076,102,102,102,051,025,051,102,102,102,076,051,025},
   {051,076,102,127,153,153,102,051,102,153,153,127,102,076,051},
   {051,102,127,153,178,204,204,102,204,204,178,153,127,102,051},
   {051,102,153,178,204,255,255,204,255,255,204,178,153,102,051},
   {051,102,153,204,255,255,255,255,255,255,255,204,153,102,051},
   {051,102,153,204,255,255,255,255,255,255,255,204,153,102,051},
   {025,051,102,153,204,255,255,255,255,255,204,153,102,051,025},
   {017,025,051,102,153,204,255,255,255,204,153,102,051,025,017},
   {000,017,025,051,102,153,204,255,204,153,102,051,025,017,000},
   {000,000,017,025,051,102,153,204,153,102,051,025,017,000,000},
   {000,000,000,017,025,051,102,153,102,051,025,017,000,000,000},
   {000,000,000,000,017,025,051,102,051,025,017,000,000,000,000},
   {000,000,000,000,000,017,025,051,025,017,000,000,000,000,000}
 }



//---------------------------------------------------------------------------
//---------------------------- objects in scene ----------------------------
//---------------------------------------------------------------------------

#declare ColorRnd  = seed (1005); // Use: "rand(ColorRnd)" 
#declare ClockRnd  = seed (1234);
#declare OffsetRnd = seed (1212);

#declare AmbiRnd = seed (10053); // Use: "rand(ColorRnd)" 
#declare SpecRnd = seed (10053); // Use: "rand(ColorRnd)" 
#declare RefRnd = seed (10053); // Use: "rand(ColorRnd)" 

#declare ArrayShape = 
  //sphere{ <0,0,0>,0.25 scale <1,1,1>
  //box { <0,0,0>,< 1.00, 0.10, 1.00>*0.9  
object {
  Round_Box(<0,0,0>,<1,0.1,1>*0.95, 0.025   , 1)  
          rotate<0,0,0> translate<0,0,0>
        }

#declare SpacerX = 1.0;
#declare SpacerZ = 1.0;
#declare CountX = 15;
#declare CountZ = 15;
#declare FilterVal = 1;
union{ //-----------------------------------------
 #local NrX = 0;     // start x
 #local EndNrX = CountX; // end   x
 #while (NrX< EndNrX) 
    // inner loop
    #local NrZ = 0;     // start z
    #local EndNrZ = CountZ; // end   z
    #while (NrZ< EndNrZ) 

      #local AmbientOffset = 2*pi*adj_range2(DriverHeart[(CountZ-1)-NrZ][NrX],0,255,1.0,0.0);
      #local AmbientVal    = (1 - sin(clock*2*pi - AmbientOffset)) * 0.5;;
     
      object{ArrayShape
         material
         {
             texture { pigment { color rgbf CHSL2RGB(<rand(ColorRnd)*360,1.0,0.5,0.7>)
                           }
                       finish  { ambient CubicBezierEase1D(1-AmbientVal,1,0,1,0)
                                 reflection 0.5
                               }
                     } // end of texture -------------------------------------------
            interior{ ior 1.5 caustics 0.5
                    } // end of interior ------------------------------------------
         } // end of material ----------------------------------------------------

         translate<NrX*SpacerX, 0, NrZ*SpacerZ>} 

    #local NrZ = NrZ + 1;  // next Nr z
    #end // --------------- end of loop z
    // end inner loop
 #declare NrX = NrX + 1;  // next Nr x
 #end // --------------- end of loop x
 // end of outer loop

rotate<0,0,0> 
translate<-((SpacerX*CountX)/2),2,-((SpacerZ*CountZ)/2)>
} // end of union ---------------------------------
