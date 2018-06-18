import java.io.*;
import java.util.*;

public class preproc {
	static int TRAIN_LIMIT = 6;
	static int TEST_LIMIT = 1;
	public static void main(String[] args) throws IOException, FileNotFoundException {
		File dataFile;
		BufferedReader br;
		String line;
		int row;
		
		System.out.println("% Facts");
		System.out.println();
		
		// For training data file.
		dataFile = new File("../data/Hill_Valley_without_noise_Training.data");
		br = new BufferedReader(new FileReader(dataFile));
		// Skip first line which has the attribute headers.
		br.readLine();
		row = 1;
		
		// Read each line and format as a fact statement for DeALS.
		while (row <= TRAIN_LIMIT && (line = br.readLine()) != null) {
			List<String> columns = Arrays.asList(line.split(","));
			// For each column attribute, output a verticalized format statement.
			for (int i = 0; i < 100; i++)
				System.out.println("train(" + row + "," + (i+1) + "," + columns.get(i) + ").");
			System.out.println("train_label(" + row + "," + columns.get(100) + ").");
			System.out.println();
			row++;
		}
		
		// For testing data file.
		dataFile = new File("../data/Hill_Valley_without_noise_Testing.data");
		br = new BufferedReader(new FileReader(dataFile));
		// Skip first line which has the attribute headers.
		br.readLine();
		row = 1;
		
		// Read each line and format as a fact statement for DeALS.
		while (row <= TEST_LIMIT && (line = br.readLine()) != null) {
			List<String> columns = Arrays.asList(line.split(","));
			// For each column attribute, output a verticalized format statement.
			for (int i = 0; i < 100; i++)
				System.out.println("test(" + row + "," + (i+1) + "," + columns.get(i) + ").");
			System.out.println("test_label(" + row + "," + columns.get(100) + ").");
			System.out.println();
			row++;
		}
		
		System.out.println("% KNN code");
		System.out.println();
		outputDeALSCode();
	}
	
	// Print the DeALS code to the output stream.
	private static void outputDeALSCode() throws IOException, FileNotFoundException {
		File codeFile;
		BufferedReader br;
		String line;
		
		codeFile = new File("knn.deal");
		br = new BufferedReader(new FileReader(codeFile));
		
		while ((line = br.readLine()) != null)
			System.out.println(line);
	}
}