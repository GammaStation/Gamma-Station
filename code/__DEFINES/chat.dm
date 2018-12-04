#define SPAN(message, span) "<span class=##span>##message</span>"

#define SPAN_WARNING(message) "<span class='warning'>##message</span>"
#define SPAN_NOTICE(message)  "<span class='notice'>##message</span>"
#define SPAN_USERDANGER(message) "<span class='userdanger'>##message</span>"
#define SPAN_BOLD(message) "<span class='bold'>##message</span>"

#define WARNING(recipient, message) to_chat(recipient, "<span class='warning'>##message</span>")
#define NOTICE(recipient, message) to_chat(recipient, "<span class='notice'>##message</span>")
#define USERDANGER(recipient, message) to_chat(recipient, "<span class='userdanger'>##message</span>")