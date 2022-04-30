//
//  meetings_tests.swift
//  Checkly_Tests
//
//  Created by a w on 28/04/2022.
//

import XCTest

@testable import Checkly

class meetings_tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_empty_meetings_array(){
        
        let vm = MeetingViewModel()
        
        XCTAssertTrue(vm.meetings.isEmpty)
    }
    
    func test_fetch_meetings_based_on_selected_date(){
        
        // Selected date is Thursday, April 28
        let viewModel = MeetingViewModel()
        
        // DATE Thursday, April 28, 2022 10:00:00 AM
        viewModel.meetings.append(Meeting(id: "-MwZ8B9T3hQBSMS0WeXh", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Meeting TEST 1", datetime_start: .init(timeIntervalSince1970: TimeInterval(1651129200)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1651131000)), type: "Online", location: "zoom.com", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"accepted", "sgWvHYIJswbVA113jWIBqcaLmgY2":"rejected"], agenda: "We will be discussing the project stakeholders", latitude: "0", longitude: "0", decisions: "-"))
        
        // DATE Wednesday, April 27, 2022 9:00:00 AM
        viewModel.meetings.append(Meeting(id: "-MyDjP9iyxma88ErQ__E", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Meeting TEST 2", datetime_start: .init(timeIntervalSince1970: TimeInterval(1651039200)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1651041000)), type: "Online", location: "zoom.com", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"accepted", "sgWvHYIJswbVA113jWIBqcaLmgY2":"rejected"], agenda: "We will be discussing the project stakeholders", latitude: "0", longitude: "0", decisions: "-"))
        
        // should return today's meeting that is on Thursday, April 28
        let ExpectedMeeting = [Meeting(id: "-MwZ8B9T3hQBSMS0WeXh", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Meeting TEST 1", datetime_start: .init(timeIntervalSince1970: TimeInterval(1651129200)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1651131000)), type: "Online", location: "zoom.com", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"accepted", "sgWvHYIJswbVA113jWIBqcaLmgY2":"rejected"], agenda: "We will be discussing the project stakeholders", latitude: "0", longitude: "0", decisions: "-")]
        
        let ReturnedMeetings = viewModel.filteredMeetingsArray(date: .init(timeIntervalSince1970: TimeInterval(1651129200)))
        
        XCTAssertEqual(ReturnedMeetings, ExpectedMeeting)
        
    }
    
    func test_selected_date_does_not_match_any_meeting(){
        
        // Selected date is Thursday, April 28
        let viewModel = MeetingViewModel()
        
        // Meetings array does not contain any meetings based on selected date
        
        // DATE Thursday, April 28, 2022 10:00:00 AM
        viewModel.meetings.append(Meeting(id: "-MwZ8B9T3hQBSMS0WeXh", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Meeting TEST 1", datetime_start: .init(timeIntervalSince1970: TimeInterval(1651129200)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1651131000)), type: "Online", location: "zoom.com", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"accepted", "sgWvHYIJswbVA113jWIBqcaLmgY2":"rejected"], agenda: "We will be discussing the project stakeholders", latitude: "0", longitude: "0", decisions: "-"))
        
        // DATE Wednesday, April 27, 2022 9:00:00 AM
        viewModel.meetings.append(Meeting(id: "-MyDjP9iyxma88ErQ__E", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Meeting TEST 2", datetime_start: .init(timeIntervalSince1970: TimeInterval(1651039200)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1651041000)), type: "Online", location: "zoom.com", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"accepted", "sgWvHYIJswbVA113jWIBqcaLmgY2":"rejected"], agenda: "We will be discussing the project stakeholders", latitude: "0", longitude: "0", decisions: "-"))
        
        // expects empty meeting array
        let ExpectedMeeting = [Meeting]()
        
        let ReturnedMeetings = viewModel.filteredMeetingsArray(date: .init(timeIntervalSince1970: TimeInterval(1651212000)))
        
        XCTAssertEqual(ReturnedMeetings, ExpectedMeeting)

    }
    
    func test_taken_meeting_attendance(){
        
        let viewModel = MeetingViewModel()
        
        // The meeting attendees status have been changed to attended and absent, thus the meeting attendane has been taken
        let result = viewModel.meetingAttendanceTaken(meeting: Meeting(id: "-MwZ8B9T3hQBSMS0WeXh", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Meeting TEST 1", datetime_start: .init(timeIntervalSince1970: TimeInterval(1651129200)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1651131000)), type: "Online", location: "zoom.com", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"attended", "sgWvHYIJswbVA113jWIBqcaLmgY2":"absent"], agenda: "We will be discussing the project stakeholders", latitude: "0", longitude: "0", decisions: "-"))
        
        XCTAssertTrue(result)
        
    }
    
    func test_untaken_meeting_attendance(){
        
        let viewModel = MeetingViewModel()
        
        // The meeting attendees status have not been changed to attended and absent, thus the meeting attendane has not been taken
        let result = viewModel.meetingAttendanceTaken(meeting: Meeting(id: "-MwZ8B9T3hQBSMS0WeXh", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Meeting TEST 1", datetime_start: .init(timeIntervalSince1970: TimeInterval(1651129200)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1651131000)), type: "Online", location: "zoom.com", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"accepted", "sgWvHYIJswbVA113jWIBqcaLmgY2":"rejected"], agenda: "We will be discussing the project stakeholders", latitude: "0", longitude: "0", decisions: "-"))
        
        XCTAssertFalse(result)
    }
    
}
