kernel vec4 combineRGBChannel(__sample red, __sample green, __sample blue, __sample rgb) {
   vec4 result = vec4(red.r, green.g, blue.b, rgb.a);
   bool isTransparency = true;
   if (red.r == 0.0 && red.g == 0.0 && red.b == 0.0 && red.a == 0.0) {
       result.r = 0.0;
   } else {
       isTransparency = false;
   }
   if (green.r == 0.0 && green.g == 0.0 && green.b == 0.0 && green.a == 0.0) {
       result.g = 0.0;
   } else {
       isTransparency = false;
   }
   if (blue.r == 0.0 && blue.g == 0.0 && blue.b == 0.0 && blue.a == 0.0) {
       result.b = 0.0;
   } else {
       isTransparency = false;
   }
   if (isTransparency) {
       result.a = 0.0;
   }
   return result;
}
