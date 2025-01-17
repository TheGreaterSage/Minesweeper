import de.bezier.guido.*;

import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
private boolean isLost = false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < buttons.length; i++) {
      for(int j = 0; j < buttons[i].length; j++) {
        buttons[i][j] = new MSButton(i, j);
      }
    }
    mines = new ArrayList<MSButton>();
    for(int i = 0; i < 100; i++)
    setMines();
}
public void setMines()
{
    int setRow = (int) (Math.random()*NUM_ROWS);
    int setCol = (int) (Math.random()*NUM_COLS);
        if(mines.contains(buttons[setRow][setCol])) {
           setMines();
        }
        else {
          mines.add(buttons[setRow][setCol]);
        }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            if (!mines.contains(buttons[i][j]) && buttons[i][j].isClicked() == false) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][9].setLabel(" ");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("O");
  buttons[9][12].setLabel("S");
  buttons[9][13].setLabel("E");
  for (int i = 0; i < mines.size(); i++)
    if (mines.get(i).isFlagged() == false)
      mines.get(i).clicked = true;
  noLoop();
}
public void displayWinningMessage()
{
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][9].setLabel(" ");
  buttons[9][10].setLabel("W");
  buttons[9][11].setLabel("I");
  buttons[9][12].setLabel("N");
  buttons[9][13].setLabel("!");
  
}
public boolean isValid(int r, int c)
{
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int i = row-1; i < row+2; i++) {
      for (int j = col-1; j < col+2; j++) {
         if (isValid(i, j) && mines.contains(buttons[i][j])) {
          numMines+=1;
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT) {
            flagged = !flagged;
            if(flagged == false) {
                clicked = false;
            }
         }
        else if(mines.contains(this)) {
            displayLosingMessage();
        }
        else if (countMines(myRow, myCol) > 0) {
            setLabel(str(countMines(myRow, myCol)));
        } 
        else {
            for (int row = myRow-1; row < myRow+2; row++) {
                for (int col = myCol-1; col < myCol+2; col++) {
                    if (isValid(row, col) && !buttons[row][col].isClicked()) {
                        buttons[row][col].mousePressed();
                    }
                }
                }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    
   
    public boolean isClicked()
    {
        return clicked;
    }
}
