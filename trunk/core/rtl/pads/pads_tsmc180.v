module inpad #(
	parameter tech = 0,
    parameter level = 0,
	parameter voltage = 0,
	parameter filter = 0
) (
	input pad,
	output o
);

	PDIDGZ padIn (
		.PAD (pad),
		.C (o)
	);	

endmodule



module outpad #(
	parameter tech=0,
	parameter level=0,
	parameter slew=0,
	parameter voltage=0,
	parameter strength=10
) (
	input i,
	output pad
);

	generate 
		if (strength < 4) begin: f4
			PDO04CDG padOut(
				.I (i),
				.PAD (pad)
			);
		end

		else if ((strength > 4) && (strength <= 12)) begin: f12
			PDO12CDG padOut(
				.I (i),
				.PAD (pad)
			);
		end

		else begin: f16
			PDO16CDG padOut (	
				.I (i),
				.PAD (pad)
			);
		end
	endgenerate

endmodule



module inpadv #(
	parameter width = 4,
	parameter tech = 0,
	parameter level = 0,
	parameter voltage = 0,
	parameter filter = 0
) (
	input [width-1:0] pad,
	output [width-1:0] o
);

// Instantiate 1-bit inpad "width" times
    genvar i;
    generate 
        for (i=0;i<width;i=i+1) begin: genblk_InPadv
            inpad #(
                .level (level),
	            .tech (tech),
	            .voltage (voltage),
		        .filter (filter)		
		    )inpad_Inst (
		        .pad (pad[i]),
		        .o (o[i])
		    );
	    end
    endgenerate
endmodule

module outpadv #(
	parameter width = 4,
	parameter tech = 0,
	parameter level = 0,
	parameter slew = 0,
	parameter voltage = 0,
	parameter strength = 0		
) (
	input [width-1:0] i,
	output [width-1:0] pad
);

    genvar k;
    generate 
	for (k=0;k<width;k=k+1) begin: genblk_OutPadv
		outpad #(
			.tech (tech),
			.level (level),
			.slew (slew),
			.voltage (voltage),
			.strength (strength)		 	
		) outpad_Inst (
			.pad (pad[k]),
			.i (i[k])
		);
	end
    endgenerate
endmodule


