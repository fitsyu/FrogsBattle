#include "gameengine.h"
#include <QDebug>
#include <QQmlProperty>
#include <QQuickItem>
#include <qmath.h>
#include <QQmlComponent>
#include <QTime>
#include <QTimer>
#define ONESTEP 260  // dist between blocks

GameEngine::GameEngine(QObject *parent) :
    QObject(parent)
{
    againstAI = false;
    playerCount = 1;
    setProperties ();
}

void GameEngine::setEngine(QQmlApplicationEngine *Engine)
{
    engine = Engine;
}

void GameEngine::newGame(int players)
{
    playerCount = players;
    if (playerCount==1) {
        againstAI = true;
    } else {
        againstAI = false;
    }

    // place blocks in starting place
    QQmlComponent component(engine, QUrl(QStringLiteral("qrc:///Block.qml")));
    if (component.status () == QQmlComponent::Ready )
    {
        block1 = qobject_cast<QQuickItem *>(component.create ());
        block1->setParentItem (place7);
        block1->setProperty ("player", 1);

        block2 = qobject_cast<QQuickItem *>(component.create ());
        block2->setParentItem (place8);
        block2->setProperty ("player", 1);

        block3 = qobject_cast<QQuickItem *>(component.create ());
        block3->setParentItem (place9);
        block3->setProperty ("player", 1);

        player1.clear ();
        player1 << block1 << block2 << block3;

        connect (block1, SIGNAL(selected()), this, SLOT(chooseBlock()));
        connect (block2, SIGNAL(selected()), this, SLOT(chooseBlock()));
        connect (block3, SIGNAL(selected()), this, SLOT(chooseBlock()));

        place7->setProperty ("filled", true);
        place8->setProperty ("filled", true);
        place9->setProperty ("filled", true);

        // ===================================
        block4 = qobject_cast<QQuickItem *>(component.create ());
        block4->setParentItem (place1);
        block4->setProperty ("player", 2);

        block5 = qobject_cast<QQuickItem *>(component.create ());
        block5->setParentItem (place2);
        block5->setProperty ("player", 2);

        block6 = qobject_cast<QQuickItem *>(component.create ());
        block6->setParentItem (place3);
        block6->setProperty ("player", 2);

        player2.clear ();
        player2 << block4 << block5 << block6;

        connect (block4, SIGNAL(selected()), this, SLOT(chooseBlock()));
        connect (block5, SIGNAL(selected()), this, SLOT(chooseBlock()));
        connect (block6, SIGNAL(selected()), this, SLOT(chooseBlock()));

        place1->setProperty ("filled", true);
        place2->setProperty ("filled", true);
        place3->setProperty ("filled", true);


        QMetaObject::invokeMethod (banner1, "takeTurn");
        selectedBlock = block1;
        turn = 1;
        toggleTurn ();
    }
//    else { qDebug () << component.errors (); }

}

void GameEngine::replayGame()
{
    newGame (playerCount); // starting new game with preserved player count
}

void GameEngine::cleanUp()
{
    // cleaning blocks...
    QList<QQuickItem *> players = player1 + player2;
    for (int p=0; p<players.length (); p++){
        players.at (p)->deleteLater ();
    }

    // cleaning places...
    for (int p=0; p<places.count (); p++){
        places.at (p)->setProperty ("filled", false);
    }

}

void GameEngine::chooseBlock()
{
    selectedBlock = qobject_cast<QQuickItem *>(sender ());
    QList<QQuickItem *> others;
    if (player1.contains (selectedBlock)){
        others = player1;
    }else {
        others = player2;
    }
    for (int b=0; b<others.count (); b++){
        QMetaObject::invokeMethod (others.at (b), "turnOff");
    }
    QMetaObject::invokeMethod (selectedBlock, "turnOn");

    startGuide (BruteForceSearchingJutsu ());
}

void GameEngine::aiMove2()
{
    moveTo(aiDestination);
}

void GameEngine::moveTo(QString place)
{
//    QQuickItem *destination = qobject_cast<QQuickItem *>(place.value<QObject *>());
    QQuickItem *destination =  qobject_cast<QQuickItem *>( parent ()->findChild<QObject *>(place) );
    if (selectedBlock){
        QQuickItem *source = selectedBlock->parentItem ();
        bool placeFilled = destination->property ("filled").toBool ();
        if ( !placeFilled ){
            int deltaX = qAbs(destination->x () - source->x ());
            int deltaY = qAbs(destination->y () - source->y ());
            qreal howFar = qSqrt ( qPow (deltaX,2) + qPow(deltaY,2) );

            bool pre1 = forbiddenPlaces.contains (destination);
            bool pre2 = forbiddenPlaces.contains (source);
            bool cantMove = pre1 && pre2;

            if (howFar < ONESTEP && !cantMove ){

                // leave it
                source->setProperty ("filled", false);
                if (turn == 1) lastEnemyPlace = source;

                // move to new place
                selectedBlock->setParentItem (destination);
                destination->setProperty ("filled", true);

                QMetaObject::invokeMethod (selectedBlock, "doinkDoink");

                // victory check!
                if ( !gameWon () ){
                    // toggle
                    if ( turn == 1){
                        turn = 2;
                    } else {
                        turn = 1;
                    }
                    toggleTurn ();
                }
                else { missionCompeleted (); } // test
            }
        }
    } else { qDebug () << "invalid block"; }
}

void GameEngine::setProperties()
{
    place1 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place1"));
    place2 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place2"));
    place3 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place3"));

    place4 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place4"));
    place5 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place5"));
    place6 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place6"));

    place7 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place7"));
    place8 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place8"));
    place9 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("place9"));

    places  << place1 << place2 << place3
            << place4 << place5 << place6
            << place7 << place8 << place9;

    forbiddenPlaces << place2 << place4
                    << place6 << place8;

    player2origin << place1 << place2 << place3;
    player1origin << place7 << place8 << place9;

    banner1 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject*>("banner1"));
    banner2 = qobject_cast<QQuickItem *>(parent ()->findChild<QObject*>("banner2"));

    gameover = qobject_cast<QQuickItem *>(parent ()->findChild<QObject *>("gameover"));


}

void GameEngine::toggleTurn()
{
    if (turn == 1 ){
        for (int b=0; b<3; b++){
            QMetaObject::invokeMethod (player1.at (b), "activate");
            QMetaObject::invokeMethod (player2.at (b), "deactivate");
        }
        QMetaObject::invokeMethod (banner1, "takeTurn");
    } else if (turn == 2) {
        for (int b=0; b<3; b++){
            QMetaObject::invokeMethod (player1.at (b), "deactivate");
            QMetaObject::invokeMethod (player2.at (b), "activate");
        }

        QMetaObject::invokeMethod (banner2, "takeTurn");
        if (againstAI) {
            QTimer::singleShot (2000, this, SLOT(aiMove()));
        }
    }


    if (selectedBlock) {
        QMetaObject::invokeMethod (selectedBlock, "turnOff");
    }
}

QList<QQuickItem *> GameEngine::BruteForceSearchingJutsu()
{
    QList<QQuickItem *> possibleMoves;
    QQuickItem *currentPlace = selectedBlock->parentItem ();

    //    first                     next
    for (int p=0; p<places.count (); p++) {

        int deltaX = qAbs(places.at (p)->x () - currentPlace->x ());
        int deltaY = qAbs(places.at (p)->y () - currentPlace->y ());
        qreal howFar = qSqrt ( qPow (deltaX,2) + qPow(deltaY,2) );

        bool pre1 = forbiddenPlaces.contains (places.at (p));
        bool pre2 = forbiddenPlaces.contains (currentPlace);
        bool cantMove = pre1 && pre2;

        bool placeFilled = places.at (p)->property ("filled").toBool ();

        // valid
        if (!cantMove && howFar < 260 && !placeFilled) {
            // output
            possibleMoves << places.at (p);
        }
    }

    return possibleMoves;
}

void GameEngine::startGuide(QList<QQuickItem *> listOfPlaces)
{
    for (int p=0; p<listOfPlaces.length(); p++){
        QMetaObject::invokeMethod (listOfPlaces.at (p), "guideHere");
    }
}

bool GameEngine::gameWon()
{
    if (inOriginPlaces(turn)) { return false; };
    // victory check
    // all three block form a row
    QList<QQuickItem *> players;
    if (turn==1)
        players = player1;
    else
        players = player2;


    // 1. has same x
    //players[0].parent.x;
    int firstX = players.at (0)->parentItem ()->x ();
    bool haveSameX = true;
    for (int b=1; b<3; b++) {
        if ( players.at (b)->parentItem ()->x () != firstX)
            haveSameX = false;
    }

    // 2. has same y
    int firstY = players.at (0)->parentItem ()->y ();
    bool haveSameY = true;
    for (int b=1; b<3; b++) {
        if ( players.at (b)->parentItem ()->y () != firstY)
            haveSameY = false;
    }

    // 3. diagonal
    bool diagonal = false;
    for (int b=0; b<3; b++) {
        if ( players.at (b)->parentItem () == place5 ) {  // one of them in the middle
            qreal deltaX, deltaY, degree;
            QList<qreal> degrees;
            qreal value=0;
            for (int c=0; c<3; c++){
                if (c==b) continue;
                deltaX = players.at (b)->parentItem ()->x () - players.at (c)->parentItem ()->x ();
                deltaY = players.at (b)->parentItem ()->y () - players.at (c)->parentItem ()->y ();
                degree = qRadiansToDegrees (atan2(deltaY,deltaX));
                degrees.append (degree);
                value += degree;
            }

            // -45, 135 || 45, -135
            if (!degrees.contains (0))
                if (qAbs(value)==90)
                    diagonal = true;

            // and not -90,180
            if (degrees[0] == -90 && degrees[1] == 180){
                diagonal = false;
            }

        }
    }

    // final check
    if ( haveSameX || haveSameY || diagonal) {
        gameover->setProperty ("winner", turn);
        QMetaObject::invokeMethod (gameover, "show");
        return true;
    }
    return false;
}

bool GameEngine::inOriginPlaces(int player)
{
    QList<QQuickItem *> blocks, originPlaces;
    if ( player == 1){
        blocks = player1;
        originPlaces = player1origin;
    } else {
        blocks = player2;
        originPlaces = player2origin;
    }

    // check list
    QQuickItem *next;
    for (int c=0; c<3; c++){
        next = blocks.at (c)->parentItem ();
        if (originPlaces.contains (next)){
            originPlaces.removeOne (next);
        }
    }
    if ( originPlaces.isEmpty () ){
        return true;
    }
    return false;
}

bool GameEngine::missionCompeleted()
{
    QList<QQuickItem *> enemyPlaces = player2origin;
    int checkList = 3;
    for (int i=0; i<player1.count (); i++){
        if ( enemyPlaces.contains (player1.at (i)->parentItem ()) )
            checkList--;
    }

    if ( checkList == 0 ) { qDebug () << "MISSION COMPLETED"; return true; }
    qDebug () << "MISSION FAILED";
    return false;
}

void GameEngine::aiMove()
{
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



    QQuickItem *destination = lastEnemyPlace;
    for (int b=0; b<3; b++){
        QQuickItem *source = player2.at (b)->parentItem ();
        int deltaX = qAbs(destination->x () - source->x ());
        int deltaY = qAbs(destination->y () - source->y ());
        qreal howFar = qSqrt ( qPow (deltaX,2) + qPow(deltaY,2) );
        bool pre1 = forbiddenPlaces.contains (destination);
        bool pre2 = forbiddenPlaces.contains (source);
        bool cantMove = pre1 && pre2;

        // it's movable block
        if (howFar < ONESTEP && !cantMove ){
            selectedBlock = player2.at (b);
            aiDestination = destination->objectName ();
            QTimer *delay = new QTimer(this);
            delay->setSingleShot (true);
            connect (delay, SIGNAL(timeout()), this, SLOT(aiMove2()));
            connect (delay, SIGNAL(timeout()), delay, SLOT(deleteLater()));
            QMetaObject::invokeMethod (selectedBlock, "turnOn");
            delay->start (3000);
            return;
        }
    }

        qsrand (QTime::currentTime ().msec ());

    //    chooseBlock ();
        selectedBlock =  player2.at (qrand () % 3);
        for (int b=0; b<player2.count (); b++) QMetaObject::invokeMethod (player2.at (b), "turnOff");
        startGuide (BruteForceSearchingJutsu ());
    //    ========

        QList<QQuickItem *> possiblePlaces = BruteForceSearchingJutsu ();
        if (possiblePlaces.isEmpty ()) {
            return aiMove();
        }else {

    //        selectedBlock.think();
            int choice = qrand () % possiblePlaces.count ();
            aiDestination = possiblePlaces.at (choice)->objectName ();
            QTimer *delay = new QTimer(this);
            delay->setSingleShot (true);
            connect (delay, SIGNAL(timeout()), this, SLOT(aiMove2()));
            connect (delay, SIGNAL(timeout()), delay, SLOT(deleteLater()));
            QMetaObject::invokeMethod (selectedBlock, "turnOn");
            delay->start (3000);
        }
}



