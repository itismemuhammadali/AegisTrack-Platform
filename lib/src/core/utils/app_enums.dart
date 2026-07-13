// App Enums

enum UserRole { traveller, hotel }

enum WaitlistStatus { active, notified, expired }

enum HotelWaitlistStatus { notified, active, pending, expired, claimed }

enum AlertCategory { alerts, updates, bookings }

enum AlertTone { urgent, success, neutral }

enum HotelInvoiceStatus { due, paid }

enum HotelActivityCategory { all, inventory, waitlist, booking, system }

enum HotelSupportTicketCategory {
  technicalIssue,
  billing,
  integrations,
  featureRequest,
  other,
}

enum HotelWaitlistTimelineStepState { done, current, pending, expired }
