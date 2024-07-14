// First initialization block ram for the
//  mips pipeline project's instruction memory
// This block represents the MSB-2 byte of the instruction word

module instructionMem3(
	input wire clk,
	input wire rd_en, 
	input wire [8:0] rd_addr, // byte addressable
	output reg [7:0] data_out, // instruction word
	output reg valid_out
   );

   reg [7:0] memory [0:511]; //512 bytes, 256 half words,
   integer i;			//128 words

   initial begin
    memory[0]=8'b11111111; // Each 4 bytes are fetched
    memory[1]=8'b11111111; //  for each instruction
    memory[2]=8'b11111111;
    memory[3]=8'b11111111;
    memory[4]=8'b11111111;
    memory[5]=8'b11111111;
    memory[6]=8'b11111111;
    memory[7]=8'b11111111;
    memory[8]=8'b11111111;
    memory[9]=8'b11111111;
    memory[10]=8'b11111111;
    memory[11]=8'b11111111;
    memory[12]=8'b11111111;
    memory[13]=8'b11111111;
    memory[14]=8'b11111111;
    memory[15]=8'b11111111;
    memory[16]=8'b11111111;
    memory[17]=8'b11111111;
    memory[18]=8'b11111111;
    memory[19]=8'b11111111;
    memory[20]=8'b11111111;
    memory[21]=8'b11111111;
    memory[22]=8'b11111111;
    memory[23]=8'b11111111;
    memory[24]=8'b11111111;
    memory[25]=8'b11111111;
    memory[26]=8'b11111111;
    memory[27]=8'b11111111;
    memory[28]=8'b11111111;
    memory[29]=8'b11111111;
    memory[30]=8'b11111111;
    memory[31]=8'b11111111;
    memory[32]=8'b11111111;
    memory[33]=8'b11111111;
    memory[34]=8'b11111111;
    memory[35]=8'b11111111;
    memory[36]=8'b11111111;
    memory[37]=8'b11111111;
    memory[38]=8'b11111111;
    memory[39]=8'b11111111;
    memory[40]=8'b11111111;
    memory[41]=8'b11111111;
    memory[42]=8'b11111111;
    memory[43]=8'b11111111;
    memory[44]=8'b11111111;
    memory[45]=8'b11111111;
    memory[46]=8'b11111111;
    memory[47]=8'b11111111;
    memory[48]=8'b11111111;
    memory[49]=8'b11111111;
    memory[50]=8'b11111111;
    memory[51]=8'b11111111;
    memory[52]=8'b11111111;
    memory[53]=8'b11111111;
    memory[54]=8'b11111111;
    memory[55]=8'b11111111;
    memory[56]=8'b11111111;
    memory[57]=8'b11111111;
    memory[58]=8'b11111111;
    memory[59]=8'b11111111;
    memory[60]=8'b11111111;
    memory[61]=8'b11111111;
    memory[62]=8'b11111111;
    memory[63]=8'b11111111;
    memory[64]=8'b11111111;
    memory[65]=8'b11111111;
    memory[66]=8'b11111111;
    memory[67]=8'b11111111;
    memory[68]=8'b11111111;
    memory[69]=8'b11111111;
    memory[70]=8'b11111111;
    memory[71]=8'b11111111;
    memory[72]=8'b11111111;
    memory[73]=8'b11111111;
    memory[74]=8'b11111111;
    memory[75]=8'b11111111;
    memory[76]=8'b11111111;
    memory[77]=8'b11111111;
    memory[78]=8'b11111111;
    memory[79]=8'b11111111;
    memory[80]=8'b11111111;
    memory[81]=8'b11111111;
    memory[82]=8'b11111111;
    memory[83]=8'b11111111;
    memory[84]=8'b11111111;
    memory[85]=8'b11111111;
    memory[86]=8'b11111111;
    memory[87]=8'b11111111;
    memory[88]=8'b11111111;
    memory[89]=8'b11111111;
    memory[90]=8'b11111111;
    memory[91]=8'b11111111;
    memory[92]=8'b11111111;
    memory[93]=8'b11111111;
    memory[94]=8'b11111111;
    memory[95]=8'b11111111;
    memory[96]=8'b11111111;
    memory[97]=8'b11111111;
    memory[98]=8'b11111111;
    memory[99]=8'b11111111;
    memory[100]=8'b11111111;
    memory[101]=8'b11111111;
    memory[102]=8'b11111111;
    memory[103]=8'b11111111;
    memory[104]=8'b11111111;
    memory[105]=8'b11111111;
    memory[106]=8'b11111111;
    memory[107]=8'b11111111;
    memory[108]=8'b11111111;
    memory[109]=8'b11111111;
    memory[110]=8'b11111111;
    memory[111]=8'b11111111;
    memory[112]=8'b11111111;
    memory[113]=8'b11111111;
    memory[114]=8'b11111111;
    memory[115]=8'b11111111;
    memory[116]=8'b11111111;
    memory[117]=8'b11111111;
    memory[118]=8'b11111111;
    memory[119]=8'b11111111;
    memory[120]=8'b11111111;
    memory[121]=8'b11111111;
    memory[122]=8'b11111111;
    memory[123]=8'b11111111;
    memory[124]=8'b11111111;
    memory[125]=8'b11111111;
    memory[126]=8'b11111111;
    memory[127]=8'b11111111;
    memory[128]=8'b11111111;
    memory[129]=8'b11111111;
    memory[130]=8'b11111111;
    memory[131]=8'b11111111;
    memory[132]=8'b11111111;
    memory[133]=8'b11111111;
    memory[134]=8'b11111111;
    memory[135]=8'b11111111;
    memory[136]=8'b11111111;
    memory[137]=8'b11111111;
    memory[138]=8'b11111111;
    memory[139]=8'b11111111;
    memory[140]=8'b11111111;
    memory[141]=8'b11111111;
    memory[142]=8'b11111111;
    memory[143]=8'b11111111;
    memory[144]=8'b11111111;
    memory[145]=8'b11111111;
    memory[146]=8'b11111111;
    memory[147]=8'b11111111;
    memory[148]=8'b11111111;
    memory[149]=8'b11111111;
    memory[150]=8'b11111111;
    memory[151]=8'b11111111;
    memory[152]=8'b11111111;
    memory[153]=8'b11111111;
    memory[154]=8'b11111111;
    memory[155]=8'b11111111;
    memory[156]=8'b11111111;
    memory[157]=8'b11111111;
    memory[158]=8'b11111111;
    memory[159]=8'b11111111;
    memory[160]=8'b11111111;
    memory[161]=8'b11111111;
    memory[162]=8'b11111111;
    memory[163]=8'b11111111;
    memory[164]=8'b11111111;
    memory[165]=8'b11111111;
    memory[166]=8'b11111111;
    memory[167]=8'b11111111;
    memory[168]=8'b11111111;
    memory[169]=8'b11111111;
    memory[170]=8'b11111111;
    memory[171]=8'b11111111;
    memory[172]=8'b11111111;
    memory[173]=8'b11111111;
    memory[174]=8'b11111111;
    memory[175]=8'b11111111;
    memory[176]=8'b11111111;
    memory[177]=8'b11111111;
    memory[178]=8'b11111111;
    memory[179]=8'b11111111;
    memory[180]=8'b11111111;
    memory[181]=8'b11111111;
    memory[182]=8'b11111111;
    memory[183]=8'b11111111;
    memory[184]=8'b11111111;
    memory[185]=8'b11111111;
    memory[186]=8'b11111111;
    memory[187]=8'b11111111;
    memory[188]=8'b11111111;
    memory[189]=8'b11111111;
    memory[190]=8'b11111111;
    memory[191]=8'b11111111;
    memory[192]=8'b11111111;
    memory[193]=8'b11111111;
    memory[194]=8'b11111111;
    memory[195]=8'b11111111;
    memory[196]=8'b11111111;
    memory[197]=8'b11111111;
    memory[198]=8'b11111111;
    memory[199]=8'b11111111;
    memory[200]=8'b11111111;
    memory[201]=8'b11111111;
    memory[202]=8'b11111111;
    memory[203]=8'b11111111;
    memory[204]=8'b11111111;
    memory[205]=8'b11111111;
    memory[206]=8'b11111111;
    memory[207]=8'b11111111;
    memory[208]=8'b11111111;
    memory[209]=8'b11111111;
    memory[210]=8'b11111111;
    memory[211]=8'b11111111;
    memory[212]=8'b11111111;
    memory[213]=8'b11111111;
    memory[214]=8'b11111111;
    memory[215]=8'b11111111;
    memory[216]=8'b11111111;
    memory[217]=8'b11111111;
    memory[218]=8'b11111111;
    memory[219]=8'b11111111;
    memory[220]=8'b11111111;
    memory[221]=8'b11111111;
    memory[222]=8'b11111111;
    memory[223]=8'b11111111;
    memory[224]=8'b11111111;
    memory[225]=8'b11111111;
    memory[226]=8'b11111111;
    memory[227]=8'b11111111;
    memory[228]=8'b11111111;
    memory[229]=8'b11111111;
    memory[230]=8'b11111111;
    memory[231]=8'b11111111;
    memory[232]=8'b11111111;
    memory[233]=8'b11111111;
    memory[234]=8'b11111111;
    memory[235]=8'b11111111;
    memory[236]=8'b11111111;
    memory[237]=8'b11111111;
    memory[238]=8'b11111111;
    memory[239]=8'b11111111;
    memory[240]=8'b11111111;
    memory[241]=8'b11111111;
    memory[242]=8'b11111111;
    memory[243]=8'b11111111;
    memory[244]=8'b11111111;
    memory[245]=8'b11111111;
    memory[246]=8'b11111111;
    memory[247]=8'b11111111;
    memory[248]=8'b11111111;
    memory[249]=8'b11111111;
    memory[250]=8'b11111111;
    memory[251]=8'b11111111;
    memory[252]=8'b11111111;
    memory[253]=8'b11111111;
    memory[254]=8'b11111111;
    memory[255]=8'b11111111;
    memory[256]=8'b11111111;
    memory[257]=8'b11111111;
    memory[258]=8'b11111111;
    memory[259]=8'b11111111;
    memory[260]=8'b11111111;
    memory[261]=8'b11111111;
    memory[262]=8'b11111111;
    memory[263]=8'b11111111;
    memory[264]=8'b11111111;
    memory[265]=8'b11111111;
    memory[266]=8'b11111111;
    memory[267]=8'b11111111;
    memory[268]=8'b11111111;
    memory[269]=8'b11111111;
    memory[270]=8'b11111111;
    memory[271]=8'b11111111;
    memory[272]=8'b11111111;
    memory[273]=8'b11111111;
    memory[274]=8'b11111111;
    memory[275]=8'b11111111;
    memory[276]=8'b11111111;
    memory[277]=8'b11111111;
    memory[278]=8'b11111111;
    memory[279]=8'b11111111;
    memory[280]=8'b11111111;
    memory[281]=8'b11111111;
    memory[282]=8'b11111111;
    memory[283]=8'b11111111;
    memory[284]=8'b11111111;
    memory[285]=8'b11111111;
    memory[286]=8'b11111111;
    memory[287]=8'b11111111;
    memory[288]=8'b11111111;
    memory[289]=8'b11111111;
    memory[290]=8'b11111111;
    memory[291]=8'b11111111;
    memory[292]=8'b11111111;
    memory[293]=8'b11111111;
    memory[294]=8'b11111111;
    memory[295]=8'b11111111;
    memory[296]=8'b11111111;
    memory[297]=8'b11111111;
    memory[298]=8'b11111111;
    memory[299]=8'b11111111;
    memory[300]=8'b11111111;
    memory[301]=8'b11111111;
    memory[302]=8'b11111111;
    memory[303]=8'b11111111;
    memory[304]=8'b11111111;
    memory[305]=8'b11111111;
    memory[306]=8'b11111111;
    memory[307]=8'b11111111;
    memory[308]=8'b11111111;
    memory[309]=8'b11111111;
    memory[310]=8'b11111111;
    memory[311]=8'b11111111;
    memory[312]=8'b11111111;
    memory[313]=8'b11111111;
    memory[314]=8'b11111111;
    memory[315]=8'b11111111;
    memory[316]=8'b11111111;
    memory[317]=8'b11111111;
    memory[318]=8'b11111111;
    memory[319]=8'b11111111;
    memory[320]=8'b11111111;
    memory[321]=8'b11111111;
    memory[322]=8'b11111111;
    memory[323]=8'b11111111;
    memory[324]=8'b11111111;
    memory[325]=8'b11111111;
    memory[326]=8'b11111111;
    memory[327]=8'b11111111;
    memory[328]=8'b11111111;
    memory[329]=8'b11111111;
    memory[330]=8'b11111111;
    memory[331]=8'b11111111;
    memory[332]=8'b11111111;
    memory[333]=8'b11111111;
    memory[334]=8'b11111111;
    memory[335]=8'b11111111;
    memory[336]=8'b11111111;
    memory[337]=8'b11111111;
    memory[338]=8'b11111111;
    memory[339]=8'b11111111;
    memory[340]=8'b11111111;
    memory[341]=8'b11111111;
    memory[342]=8'b11111111;
    memory[343]=8'b11111111;
    memory[344]=8'b11111111;
    memory[345]=8'b11111111;
    memory[346]=8'b11111111;
    memory[347]=8'b11111111;
    memory[348]=8'b11111111;
    memory[349]=8'b11111111;
    memory[350]=8'b11111111;
    memory[351]=8'b11111111;
    memory[352]=8'b11111111;
    memory[353]=8'b11111111;
    memory[354]=8'b11111111;
    memory[355]=8'b11111111;
    memory[356]=8'b11111111;
    memory[357]=8'b11111111;
    memory[358]=8'b11111111;
    memory[359]=8'b11111111;
    memory[360]=8'b11111111;
    memory[361]=8'b11111111;
    memory[362]=8'b11111111;
    memory[363]=8'b11111111;
    memory[364]=8'b11111111;
    memory[365]=8'b11111111;
    memory[366]=8'b11111111;
    memory[367]=8'b11111111;
    memory[368]=8'b11111111;
    memory[369]=8'b11111111;
    memory[370]=8'b11111111;
    memory[371]=8'b11111111;
    memory[372]=8'b11111111;
    memory[373]=8'b11111111;
    memory[374]=8'b11111111;
    memory[375]=8'b11111111;
    memory[376]=8'b11111111;
    memory[377]=8'b11111111;
    memory[378]=8'b11111111;
    memory[379]=8'b11111111;
    memory[380]=8'b11111111;
    memory[381]=8'b11111111;
    memory[382]=8'b11111111;
    memory[383]=8'b11111111;
    memory[384]=8'b11111111;
    memory[385]=8'b11111111;
    memory[386]=8'b11111111;
    memory[387]=8'b11111111;
    memory[388]=8'b11111111;
    memory[389]=8'b11111111;
    memory[390]=8'b11111111;
    memory[391]=8'b11111111;
    memory[392]=8'b11111111;
    memory[393]=8'b11111111;
    memory[394]=8'b11111111;
    memory[395]=8'b11111111;
    memory[396]=8'b11111111;
    memory[397]=8'b11111111;
    memory[398]=8'b11111111;
    memory[399]=8'b11111111;
    memory[400]=8'b11111111;
    memory[401]=8'b11111111;
    memory[402]=8'b11111111;
    memory[403]=8'b11111111;
    memory[404]=8'b11111111;
    memory[405]=8'b11111111;
    memory[406]=8'b11111111;
    memory[407]=8'b11111111;
    memory[408]=8'b11111111;
    memory[409]=8'b11111111;
    memory[410]=8'b11111111;
    memory[411]=8'b11111111;
    memory[412]=8'b11111111;
    memory[413]=8'b11111111;
    memory[414]=8'b11111111;
    memory[415]=8'b11111111;
    memory[416]=8'b11111111;
    memory[417]=8'b11111111;
    memory[418]=8'b11111111;
    memory[419]=8'b11111111;
    memory[420]=8'b11111111;
    memory[421]=8'b11111111;
    memory[422]=8'b11111111;
    memory[423]=8'b11111111;
    memory[424]=8'b11111111;
    memory[425]=8'b11111111;
    memory[426]=8'b11111111;
    memory[427]=8'b11111111;
    memory[428]=8'b11111111;
    memory[429]=8'b11111111;
    memory[430]=8'b11111111;
    memory[431]=8'b11111111;
    memory[432]=8'b11111111;
    memory[433]=8'b11111111;
    memory[434]=8'b11111111;
    memory[435]=8'b11111111;
    memory[436]=8'b11111111;
    memory[437]=8'b11111111;
    memory[438]=8'b11111111;
    memory[439]=8'b11111111;
    memory[440]=8'b11111111;
    memory[441]=8'b11111111;
    memory[442]=8'b11111111;
    memory[443]=8'b11111111;
    memory[444]=8'b11111111;
    memory[445]=8'b11111111;
    memory[446]=8'b11111111;
    memory[447]=8'b11111111;
    memory[448]=8'b11111111;
    memory[449]=8'b11111111;
    memory[450]=8'b11111111;
    memory[451]=8'b11111111;
    memory[452]=8'b11111111;
    memory[453]=8'b11111111;
    memory[454]=8'b11111111;
    memory[455]=8'b11111111;
    memory[456]=8'b11111111;
    memory[457]=8'b11111111;
    memory[458]=8'b11111111;
    memory[459]=8'b11111111;
    memory[460]=8'b11111111;
    memory[461]=8'b11111111;
    memory[462]=8'b11111111;
    memory[463]=8'b11111111;
    memory[464]=8'b11111111;
    memory[465]=8'b11111111;
    memory[466]=8'b11111111;
    memory[467]=8'b11111111;
    memory[468]=8'b11111111;
    memory[469]=8'b11111111;
    memory[470]=8'b11111111;
    memory[471]=8'b11111111;
    memory[472]=8'b11111111;
    memory[473]=8'b11111111;
    memory[474]=8'b11111111;
    memory[475]=8'b11111111;
    memory[476]=8'b11111111;
    memory[477]=8'b11111111;
    memory[478]=8'b11111111;
    memory[479]=8'b11111111;
    memory[480]=8'b11111111;
    memory[481]=8'b11111111;
    memory[482]=8'b11111111;
    memory[483]=8'b11111111;
    memory[484]=8'b11100000;
    memory[485]=8'b01111111;
    memory[486]=8'b11111111;
    memory[487]=8'b11111111;
    memory[488]=8'b11111111;
    memory[489]=8'b11111111;
    memory[490]=8'b11111111;
    memory[491]=8'b11111111;
    memory[492]=8'b11111111;
    memory[493]=8'b11111111;
    memory[494]=8'b11111111;
    memory[495]=8'b11111111;
    memory[496]=8'b11111111;
    memory[497]=8'b11111111;
    memory[498]=8'b11111111;
    memory[499]=8'b11111111;
    memory[500]=8'b11111111;
    memory[501]=8'b11111111;
    memory[502]=8'b11111111;
    memory[503]=8'b11111111;
    memory[504]=8'b00000000;
    memory[505]=8'b00011100;
    memory[506]=8'b00000111;
    memory[507]=8'b11100001;
    memory[508]=8'b11111000;
    memory[509]=8'b00111000;
    memory[510]=8'b00000000;
    memory[511]=8'b01111000; 
    valid_out = 0;
   end

   always @(posedge clk)
   begin
      // default
      valid_out <= 0;

      if (rd_en) begin
	 data_out <= memory[rd_addr];
         valid_out <= 1;
      end
   end
endmodule
