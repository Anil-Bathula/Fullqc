global class TimeTradeService  {
//For Hult Project, to integrate with TimeTrade : 082013


    public class PreviousApptType {
        public String classx;
        public Object description;
        public Object durationInMinutes;
        public Object id;
        public Object name;
    }

    public class ApptType {
        public String classx;
        public String description;
        public double durationInMinutes;
        public String id;
        public String name;
    }

    public class CustomValues_Z {
        public String Answer1;
        public String Answer0;
        public String ClientBirthDate;
    }
    
    public class PreviousLocation {
        public Object address;
        public String classx;
        public Object description;
        public Object emailAddress;
        public Object faxNumber;
        public Object id;
        public Object name;
        public Object phoneNumber;
        public Object timeZone;
    }
    
    public class PreviousAppt {
        public Object attachmentURLs;
        public String classx;
        public Object comment;
        public Object conferenceSystemID;
        public Object confirmationNumber;
        public AttachmentURLs customValues;
        public Object fulfillmentInstructions;
        public Object fulfillmentMethod;
        public String id;
        public Object isCheckedIn;
        public Object isCheckedOut;
        public Object isConfirmed;
        public Object isWalkin;
        public Object responses;
        public Long scheduledEndTime;
        public Long scheduledStartTime;
        public Object timeZone;
    }
    
    public class PreviousResources {
        public Object externalIDs;
        public String classx;
        public Object emailAddress;
        public Object firstName;
        public Object id;
        public Object lastName;
        public Object phoneNumber;
        public Object resourcePoolID;
        public Object timeZone;
    }
    
    public class PreviousAttendees {
        public Object externalIDs;
        public Object address;
        public String classx;
        public Object comment;
        public Object company;
        public AttachmentURLs customValues;
        public Object emailAddress;
        public Object emailPermitted;
        public Object faxNumber;
        public Object firstName;
        public Object gender;
        public Object homePhoneNumber;
        public Object id;
        public Object jobTitle;
        public Object language;
        public Object lastName;
        public Object mobilePhoneNumber;
        public Object salutation;
        public Object smsPermitted;
        public Object timeZone;
        public Object workPhoneNumber;
    }

    public class PreviousLicensee {
        public Object externalIDs;
        public String classx;
        public Object licenseeID;
        public Object name;
    }


    public class Responses {
        public String answer;
        public String classx;
        public String questionExternalID;
        public String questionText;
    }

    public class Appt {
        public List<AttachmentURLs> attachmentURLs;
        public String classx;
        public String comment;
        public String conferenceSystemID;
        public String confirmationNumber;
        public CustomValues customValues;
        public String fulfillmentInstructions;
        public String fulfillmentMethod;
        public String id;
        public Boolean isCheckedIn;
        public Boolean isCheckedOut;
        public Boolean isConfirmed;
        public Boolean isWalkin;
        public List<Responses> responses;
        public Long scheduledEndTime;
        public Long scheduledStartTime;
        public String timeZone;
    }

    public class Location {
        public Address address;
        public String classx;
        public String description;
        public String emailAddress;
        public String faxNumber;
        public String id;
        public String name;
        public String phoneNumber;
        public String timeZone;
    }

    public class Attendees {
        public AttachmentURLs externalIDs;
        public Address address;
        public String classx;
        public String comment;
        public String company;
        public CustomValues_Z customValues;
        public String emailAddress;
        public Boolean emailPermitted;
        public String faxNumber;
        public String firstName;
        public String gender;
        public String homePhoneNumber;
        public String id;
        public String jobTitle;
        public String language;
        public String lastName;
        public String mobilePhoneNumber;
        public String salutation;
        public Boolean smsPermitted;
        public String timeZone;
        public String workPhoneNumber;
    }

    public class Fulfillment {
        public String classx;
        public List<FulfillmentLog> fulfillmentLog;
    }

   public Appt appt;
    public ApptType apptType;
    public List<Attendees> attendees;
    public Object callToken;
    public String classx;
    public Object details;
    public Object durationMsecs;
    public String eventClass;
    public String eventName;
    public EventToken eventToken;
    public Fulfillment fulfillment;
    public List<AttachmentURLs> headers;
    public Object httpVerb;
    public Licensee licensee;
    public Object limitx;
    public Location location;
    public Object methodUri;
    public Object module;
    public Object payloadBody;
    public PreviousAppt previousAppt;
    public PreviousApptType previousApptType;
    public List<PreviousAttendees> previousAttendees;
    public PreviousLicensee previousLicensee;
    public PreviousLocation previousLocation;
    public List<PreviousResources> previousResources;
    public Producer producer;
    public Object registration;
    public List<Resources> resources;
    public Object returnStatusCode;
    public Object subscription;
    
    public class Address {
        public String addressA;
        public String addressB;
        public String city;
        public String classx;
        public String country;
        public String latitude;
        public String longitude;
        public String postalCode;
        public String state;
    }

    public class AttachmentURLs {
    }

    public class EventToken {
        public String classx;
        public String uuid;
    }

    public class Producer {
        public String classx;
        public String discardText;
        public String eventUUID;
        public String host;
        public Boolean isDiscard;
        public String replayConsumerTypeId;
        public Integer replayCount;
        public Integer threadID;
        public Long timestamp;
        public String version;
    }

    public class FulfillmentLog {
        public String actionDetails;
        public String actionID;
        public String classx;
        public Long occurredAt;
        public String userID;
    }

    public class Resources {
        public AttachmentURLs externalIDs;
        public String classx;
        public String emailAddress;
        public String firstName;
        public String id;
        public String lastName;
        public String phoneNumber;
        public String resourcePoolID;
        public String timeZone;
    }

    public class CustomValues {
        public String ProgramName;
        public String ProgramExternalId;
    }

    public class Licensee {
        public AttachmentURLs externalIDs;
        public String classx;
        public String licenseeID;
        public String name;
    }
}