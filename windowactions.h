#ifndef WINDOWACTIONS_H
#define WINDOWACTIONS_H

#include <QObject>

class WindowActions : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool hasFocus READ hasFocus NOTIFY focusChanged)

public:
    explicit WindowActions(QObject *parent = 0);
    
    bool hasFocus() const;

signals:
    void focusChanged();

private slots:
    void windowFocusChanged(QWidget *old, QWidget *now);
    
private:
    bool m_hasFocus;

};

#endif // WINDOWACTIONS_H
