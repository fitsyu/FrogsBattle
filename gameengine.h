#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQuickItem>
#include <QPointer>

class GameEngine : public QObject
{
    Q_OBJECT
public:
    explicit GameEngine(QObject *parent = 0);
    void setEngine(QQmlApplicationEngine *);
    Q_INVOKABLE void newGame(int players);
    Q_INVOKABLE void replayGame();
    Q_INVOKABLE void cleanUp();

public slots:
    void chooseBlock();
    void aiMove();
    void aiMove2();
    Q_INVOKABLE void moveTo(QString place);

protected:
    void setProperties();
    void toggleTurn();

    QList<QQuickItem *> BruteForceSearchingJutsu();
    void startGuide(QList<QQuickItem *> listOfPlaces);

    bool gameWon();
    bool inOriginPlaces(int player);
    bool missionCompeleted(); // ?
private:
    // const
    QQuickItem *block1, *block2, *block3;
    QQuickItem *block4, *block5, *block6;

    QQuickItem *place1, *place2, *place3;
    QQuickItem *place4, *place5, *place6;
    QQuickItem *place7, *place8, *place9;

    QList<QQuickItem *> player1;   // List of player blocks
    QList<QQuickItem *> player2;

    QList<QQuickItem *> places;    // List of places
    QList<QQuickItem *> forbiddenPlaces;
    QList<QQuickItem *> player1origin;
    QList<QQuickItem *> player2origin;

    QQuickItem *banner1;
    QQuickItem *banner2;
    QQuickItem *gameover;

    // variables
    QPointer<QQuickItem> selectedBlock;
    int turn;

    // AI stuff
    bool againstAI;
    QString aiDestination;
    QQuickItem *lastEnemyPlace;

    int playerCount;

    QQmlApplicationEngine *engine;
};

#endif // GAMEENGINE_H
