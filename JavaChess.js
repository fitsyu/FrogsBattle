var selectedBlock;
var block1, block2, block3;
var block4, block5, block6;

var turn = 1;
var againstAI = false

function newGame(playerCount){
    if (playerCount==1) {
        againstAI = true
    } else {
        againstAI = false
    }

    // place blocks in starting place
    var component = Qt.createComponent("Block.qml");
    if (component.status == Component.Ready )
    {
        block1 = component.createObject(place7, {"player":1});
        block2 = component.createObject(place8, {"player":1});
        block3 = component.createObject(place9, {"player":1});

        block1.selected.connect(chooseBlock1);
        block2.selected.connect(chooseBlock2);
        block3.selected.connect(chooseBlock3);

        place7.filled = true;
        place8.filled = true;
        place9.filled = true;

        // ===================================

        block4 = component.createObject(place1, {"player":2});
        block5 = component.createObject(place2, {"player":2});
        block6 = component.createObject(place3, {"player":2});

        block4.selected.connect(chooseBlock4);
        block5.selected.connect(chooseBlock5);
        block6.selected.connect(chooseBlock6);

        place1.filled = true;
        place2.filled = true;
        place3.filled = true;

        banner1.takeTurn();
        disableBlocks(1);
    }
}



function moveTo(place)
{
    // CONDITION
    // place is empty
    // place reachable from current place


    var forbiddenMoves = [place2, place4, place6, place8];

    if ( selectedBlock != null){
        if (!place.filled){  // empty
            var deltaX = Math.abs(place.x - selectedBlock.parent.x);
            var deltaY = Math.abs(place.y - selectedBlock.parent.y);
            var howFar = Math.sqrt( (Math.pow(deltaX,2) + Math.pow(deltaY,2)) );

            var pre1 = forbiddenMoves.indexOf(selectedBlock.parent)==-1?false:true;
            var pre2 = forbiddenMoves.indexOf(place)==-1?false:true;
            var cannotMove = (pre1 && pre2);

            if ( howFar < 260 && !cannotMove) {
                selectedBlock.parent.filled = false;
                selectedBlock.parent = place;
                selectedBlock.doinkDoink();

                place.filled = true;

                // victory check
                if ( !gameWon(turn) ){
                    // toggle
                    if (turn == 1) {
                        turn = 2;
                        if (againstAI) aiMove();
                    } else {
                        turn =1;
                    }
                    disableBlocks(turn);
                }
            }
        }
    }
}

function disableBlocks(t){
    var player1 = [block1, block2, block3];
    var player2 = [block4, block5, block6];
    if (t==1){
        for (var b=0; b<3; b++) {
            player1[b].activate();
            player2[b].deactivate();
        }
        banner1.takeTurn();
    } else {
        for (var b=0; b<3; b++) {
            player1[b].deactivate();
            player2[b].activate();
        }
        banner2.takeTurn();
    }

    if (selectedBlock != null){
        selectedBlock.turnOff();
        selectedBlock = null;
    }
}

function gameWon(p)
{
    if (inOriginPlaces(p)) { return false; };
    // victory check
    // all three block form a row
    var players ;
    if (p==1){
        players = [block1, block2, block3];
    }
    else {
        players = [block4, block5, block6];
    }

    // has same x
    var firstX = players[0].parent.x;
    var haveSameX = true;
    for (var b=1; b<3; b++) {
        if (players[b].parent.x != firstX) haveSameX = false;
    }

    // has same y
    var firstY = players[0].parent.y;
    var haveSameY = true;
    for (var b=1; b<3; b++) {
        if (players[b].parent.y != firstY) haveSameY = false;
    }

    // diagonal
    var diagonal = false;
    for (var b=0; b<3; b++) {
        if (players[b].parent == place5) {
            var deltaX, deltaY, degree;
            var degrees=[];
            var value=0;
            for (var c=0; c<3; c++){
                if (c==b) continue;
                deltaX = players[b].parent.x - players[c].parent.x;
                deltaY = players[b].parent.y - players[c].parent.y;
                degree = Math.atan2(deltaY,deltaX) * 180/Math.PI;
                degrees.push(degree);
                value += degree;
            }

            // -45, 135 || 45, -135


            if (degrees.indexOf(0)==-1)
                if (Math.abs(value)==90)
                    diagonal = true;

            // and not -90,180
            if (degrees[0] == -90 && degrees[1] == 180){
                diagonal = false;
            }

        }
    }

    if ( haveSameX || haveSameY || diagonal) {
        gameover.winner = turn;
        gameover.show();
        return true;
    }
    return false;
}

function cleanUp(){
    var players = [block1, block2, block3, block4, block5, block6];
    for (var p=0; p<players.length; p++)
        players[p].destroy();

    var places =  [place1, place2, place3,
                   place4, place5, place6,
                   place7, place8, place9];
    for (var p=0; p<places.length; p++)
        places[p].filled = false;

}

function searchPlacesWithBruteForce(){
    var forbiddenMoves = [place2, place4, place6, place8];
    var places =  [place1, place2, place3,
                   place4, place5, place6,
                   place7, place8, place9];

    var possibleMoves = [];
    var pre1, pre2, cannotMove;


    var deltaX, deltaY, howFar;
    for (var p=0; p<places.length; p++) {
        pre1 = forbiddenMoves.indexOf(selectedBlock.parent)==-1?false:true;
        pre2 = forbiddenMoves.indexOf(places[p])==-1?false:true;
        cannotMove = (pre1 && pre2);

        deltaX = Math.abs(places[p].x - selectedBlock.parent.x);
        deltaY = Math.abs(places[p].y - selectedBlock.parent.y);
        howFar = Math.sqrt( (Math.pow(deltaX,2) + Math.pow(deltaY,2)) );

        if (!cannotMove && howFar < 260 && !places[p].filled) {
            possibleMoves.push(places[p]);
        }
    }

    return possibleMoves;
}

function startGuide(listOfPlaces){
    for (var p=0; p<listOfPlaces.length; p++){
        listOfPlaces[p].guideHere();
    }
}

function aiMove(){
    /*
      Stupid Mode
      0. choose a block
      1. search possible moves
      2. choose the best
      3. move there

      Rather Smart
      0. take sides never middle one
      1. try to follow enemy move
      2. else enter stupid mode
    */

    var places =  [place1, place2, place3,
                   place4, place5, place6,
                   place7, place8, place9];

    var myChoice;
    myChoice = Math.ceil(Math.random()*3)+3;
    switch (myChoice) {
    case 4:
        chooseBlock4(); break;
    case 5:
        chooseBlock5(); break;
    case 6:
        chooseBlock6(); break;
    default:
        chooseBlock6(); break;
    }

    var possiblePlaces = searchPlacesWithBruteForce();

    if (possiblePlaces.length==0) {
        return aiMove();
    }else {
        myChoice = Math.ceil(Math.random()*possiblePlaces.length)-1;
//        banner2.takeTurn();
        selectedBlock.think();
        moveTo(possiblePlaces[myChoice]);
    }
}

function inOriginPlaces(p){
    var originPlaces =[];
    var blocks=[];

    if ( p == 1){
        blocks = [block1, block2, block3];
        originPlaces = [place7, place8, place9];

    }
    else if (p==2){
        blocks = [block4, block5, block6];
        originPlaces = [place1, place2, place3];
    }

    var inPlaces=0;
    for (var b=0; b<3; b++){
        if (originPlaces.indexOf(blocks[b].parent) != -1){
            inPlaces++;
        }
    }

    if (inPlaces == 3) { return true; }
    return false;
}

function chooseBlock1() {
    selectedBlock = block1;
    block1.turnOn();
    block2.turnOff(); block3.turnOff();
    startGuide(searchPlacesWithBruteForce());
}
function chooseBlock2() {
    selectedBlock = block2;
    block2.turnOn();
    block3.turnOff(); block1.turnOff();
    startGuide(searchPlacesWithBruteForce());
}
function chooseBlock3() {
    selectedBlock = block3;
    block3.turnOn();
    block1.turnOff(); block2.turnOff();
    startGuide(searchPlacesWithBruteForce());
}
function chooseBlock4() {
    selectedBlock = block4;
    block4.turnOn();
    block5.turnOff(); block6.turnOff();
    startGuide(searchPlacesWithBruteForce());
}
function chooseBlock5() {
    selectedBlock = block5;
    block5.turnOn();
    block6.turnOff(); block4.turnOff();
    startGuide(searchPlacesWithBruteForce());
}
function chooseBlock6() {
    selectedBlock = block6;
    block6.turnOn();
    block4.turnOff(); block5.turnOff();
    startGuide(searchPlacesWithBruteForce());
}
