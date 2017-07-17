package cs.min2phaseWrapper;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import cs.min2phase.Search;
import cs.min2phase.Tools;

public class SimpleTwophaseWrapper {
	Search m_search = new Search();

	/**
	 * Inits conversion tables.
	 */
	public void InitTables()
	{
                if (!Tools.isInited())
			Tools.init(); 
	
		/*try {
			System.out.println("Trying to load tables from file...");
			DataInputStream dis = new DataInputStream(new BufferedInputStream(new FileInputStream("data")));
			Tools.initFrom(dis);
			System.out.println("Tables loaded from file!");
		} catch (FileNotFoundException e) {
		} catch (IOException e) {
			System.out.println("Error on loading tables from file!");
			e.printStackTrace();
		}
		
		if (!Tools.isInited()) {
			System.out.print("Creating tables from scratch...");
			Tools.init(); 
			System.out.println("Tables created!");
			try {
				System.out.println("Trying to save tables to file...");
				DataOutputStream dos = new DataOutputStream(new BufferedOutputStream(new FileOutputStream("data")));
				Tools.saveTo(dos);
				dos.close();
				System.out.println("Tables saved to file!");
			} catch (IOException e) {
				System.out.println("Error on saving tables to file!");
				e.printStackTrace();
			}
		}*/
	}
	
	/**
	 * Computes the solver string for a given cube.
	 *
	 * @param facelets
	 * 		is the cube definition string format.<br>
	 * The names of the facelet positions of the cube:
	 * <pre>
	 *             |************|
	 *             |*U1**U2**U3*|
	 *             |************|
	 *             |*U4**U5**U6*|
	 *             |************|
	 *             |*U7**U8**U9*|
	 *             |************|
	 * ************|************|************|************|
	 * *L1**L2**L3*|*F1**F2**F3*|*R1**R2**F3*|*B1**B2**B3*|
	 * ************|************|************|************|
	 * *L4**L5**L6*|*F4**F5**F6*|*R4**R5**R6*|*B4**B5**B6*|
	 * ************|************|************|************|
	 * *L7**L8**L9*|*F7**F8**F9*|*R7**R8**R9*|*B7**B8**B9*|
	 * ************|************|************|************|
	 *             |************|
	 *             |*D1**D2**D3*|
	 *             |************|
	 *             |*D4**D5**D6*|
	 *             |************|
	 *             |*D7**D8**D9*|
	 *             |************|
	 * </pre>
	 * A cube definition string "UBL..." means for example: In position U1 we have the U-color, in position U2 we have the
	 * B-color, in position U3 we have the L color etc. according to the order U1, U2, U3, U4, U5, U6, U7, U8, U9, R1, R2,
	 * R3, R4, R5, R6, R7, R8, R9, F1, F2, F3, F4, F5, F6, F7, F8, F9, D1, D2, D3, D4, D5, D6, D7, D8, D9, L1, L2, L3, L4,
	 * L5, L6, L7, L8, L9, B1, B2, B3, B4, B5, B6, B7, B8, B9 of the enum constants.
	 *
	 * @param maxDepth
	 * 		defines the maximal allowed maneuver length. For random cubes, a maxDepth of 21 usually will return a
	 * 		solution in less than 0.02 seconds on average. With a maxDepth of 20 it takes about 0.1 seconds on average to find a
	 * 		solution, but it may take much longer for specific cubes.
	 *
	 * @param timeOut
	 * 		defines the maximum computing time of the method in milliseconds. If it does not return with a solution, it returns with
	 * 		an error code.
	 *
	 * @param timeMin
	 * 		defines the minimum computing time of the method in milliseconds. So, if a solution is found within given time, the
	 * 		computing will continue to find shorter solution(s). Btw, if timeMin > timeOut, timeMin will be set to timeOut.
	 * 
	 * @return The solution string or an error code:<br>
	 * 		Error 1: There is not exactly one facelet of each colour<br>
	 * 		Error 2: Not all 12 edges exist exactly once<br>
	 * 		Error 3: Flip error: One edge has to be flipped<br>
	 * 		Error 4: Not all corners exist exactly once<br>
	 * 		Error 5: Twist error: One corner has to be twisted<br>
	 * 		Error 6: Parity error: Two corners or two edges have to be exchanged<br>
	 * 		Error 7: No solution exists for the given maxDepth<br>
	 * 		Error 8: Timeout, no solution within given time
	 */
	public String SolveCube(String facelets, int maxDepth, int timeOut, int timeMin) {
		return m_search.solution(facelets, maxDepth, timeOut, timeMin, 0);
	}
	
	/**
	 * Verifies the given facelets string.
	 *
	 * @param facelets
	 * 		is the cube definition string format.<br>
	 * The names of the facelet positions of the cube:
	 * <pre>
	 *             |************|
	 *             |*U1**U2**U3*|
	 *             |************|
	 *             |*U4**U5**U6*|
	 *             |************|
	 *             |*U7**U8**U9*|
	 *             |************|
	 * ************|************|************|************|
	 * *L1**L2**L3*|*F1**F2**F3*|*R1**R2**F3*|*B1**B2**B3*|
	 * ************|************|************|************|
	 * *L4**L5**L6*|*F4**F5**F6*|*R4**R5**R6*|*B4**B5**B6*|
	 * ************|************|************|************|
	 * *L7**L8**L9*|*F7**F8**F9*|*R7**R8**R9*|*B7**B8**B9*|
	 * ************|************|************|************|
	 *             |************|
	 *             |*D1**D2**D3*|
	 *             |************|
	 *             |*D4**D5**D6*|
	 *             |************|
	 *             |*D7**D8**D9*|
	 *             |************|
	 * </pre>
	 * A cube definition string "UBL..." means for example: In position U1 we have the U-color, in position U2 we have the
	 * B-color, in position U3 we have the L color etc. according to the order U1, U2, U3, U4, U5, U6, U7, U8, U9, R1, R2,
	 * R3, R4, R5, R6, R7, R8, R9, F1, F2, F3, F4, F5, F6, F7, F8, F9, D1, D2, D3, D4, D5, D6, D7, D8, D9, L1, L2, L3, L4,
	 * L5, L6, L7, L8, L9, B1, B2, B3, B4, B5, B6, B7, B8, B9 of the enum constants.
	 *
	 * @return The solution string or an error code:<br>
	 * 		Error 1: There is not exactly one facelet of each colour<br>
	 * 		Error 2: Not all 12 edges exist exactly once<br>
	 * 		Error 3: Flip error: One edge has to be flipped<br>
	 * 		Error 4: Not all corners exist exactly once<br>
	 * 		Error 5: Twist error: One corner has to be twisted<br>
	 * 		Error 6: Parity error: Two corners or two edges have to be exchanged
	 */
	public int VerifyCube(String facelets) {
		return m_search.verify(facelets);
	}
}
