#ifndef BLUETOOTHCLIENT_H
#define BLUETOOTHCLIENT_H

#include <QObject>
#include <QBluetoothSocket>

class BluetoothClient : public QObject
{
    Q_OBJECT

public:
    explicit BluetoothClient(QObject *parent = 0);

    Q_INVOKABLE void sendData(const QString &data);
    Q_INVOKABLE void connectTo(const QString &macAddress);
    Q_INVOKABLE void disconnect();

signals:
    void telegramReceived(const QString &macAddress, const QString &telegram);
    void connected(const QString &macAddress, const QString &name);
    void disconnected();
    void error(const QString &errorMessage);

private slots:
    void slotReadData();
    void slotConnected();
    void slotDisconnected();
    void slotError();

private:
    QString m_receivedData; /**< Contains chunks of data between STX and ETX. */
    QString m_macAddress;   /**< Holds the MAC adress for re-connect. */
    QBluetoothSocket *m_socket;

};

#endif // BLUETOOTHCLIENT_H
