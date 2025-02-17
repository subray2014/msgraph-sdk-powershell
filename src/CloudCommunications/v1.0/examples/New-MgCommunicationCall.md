### Example 1: Create peer-to-peer VoIP call with service hosted media

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	callbackUri = "https://bot.contoso.com/callback"
	targets = @(
		@{
			"@odata.type" = "#microsoft.graph.invitationParticipantInfo"
			identity = @{
				"@odata.type" = "#microsoft.graph.identitySet"
				user = @{
					"@odata.type" = "#microsoft.graph.identity"
					displayName = "John"
					id = "112f7296-5fa4-42ca-bae8-6a692b15d4b8"
				}
			}
		}
	)
	requestedModalities = @(
		"audio"
	)
	callOptions = @{
		"@odata.type" = "#microsoft.graph.outgoingCallOptions"
		isContentSharingNotificationEnabled = $true
	}
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.serviceHostedMediaConfig"
	}
}

New-MgCommunicationCall -BodyParameter $params

```
This example will create peer-to-peer voip call with service hosted media

### Example 2: Create peer-to-peer VoIP call with application hosted media

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	callbackUri = "https://bot.contoso.com/callback"
	source = @{
		"@odata.type" = "#microsoft.graph.participantInfo"
		identity = @{
			"@odata.type" = "#microsoft.graph.identitySet"
			application = @{
				"@odata.type" = "#microsoft.graph.identity"
				displayName = "Calling Bot"
				id = "2891555a-92ff-42e6-80fa-6e1300c6b5c6"
			}
		}
		region = $null
		languageId = $null
	}
	targets = @(
		@{
			"@odata.type" = "#microsoft.graph.invitationParticipantInfo"
			identity = @{
				"@odata.type" = "#microsoft.graph.identitySet"
				user = @{
					"@odata.type" = "#microsoft.graph.identity"
					displayName = "John"
					id = "112f7296-5fa4-42ca-bae8-6a692b15d4b8"
				}
			}
		}
	)
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.appHostedMediaConfig"
		blob = "<Media Session Configuration>"
	}
}

New-MgCommunicationCall -BodyParameter $params

```
This example will create peer-to-peer voip call with application hosted media

### Example 3: Create a group call with service hosted media

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	direction = "outgoing"
	subject = "Create a group call with service hosted media"
	callbackUri = "https://bot.contoso.com/callback"
	source = @{
		"@odata.type" = "#microsoft.graph.participantInfo"
		identity = @{
			"@odata.type" = "#microsoft.graph.identitySet"
			application = @{
				"@odata.type" = "#microsoft.graph.identity"
				displayName = "TestBot"
				id = "dd3885da-f9ab-486b-bfae-85de3d445555"
			}
		}
	}
	targets = @(
		@{
			"@odata.type" = "#microsoft.graph.invitationParticipantInfo"
			identity = @{
				"@odata.type" = "#microsoft.graph.identitySet"
				user = @{
					"@odata.type" = "#microsoft.graph.identity"
					displayName = "user1"
					id = "98da8a1a-1b87-452c-a713-65d3f10b5555"
				}
			}
		}
		@{
			"@odata.type" = "#microsoft.graph.invitationParticipantInfo"
			identity = @{
				"@odata.type" = "#microsoft.graph.identitySet"
				user = @{
					"@odata.type" = "#microsoft.graph.identity"
					displayName = "user2"
					id = "bf5aae9a-d11d-47a8-93b1-782504c95555"
				}
			}
		}
	)
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.serviceHostedMediaConfig"
		removeFromDefaultAudioGroup = $false
	}
}

New-MgCommunicationCall -BodyParameter $params

```
This example will create a group call with service hosted media

### Example 4: Create a group call with application hosted media

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	direction = "outgoing"
	subject = "Create a group call with application hosted media"
	callbackUri = "https://bot.contoso.com/callback"
	source = @{
		"@odata.type" = "#microsoft.graph.participantInfo"
		identity = @{
			"@odata.type" = "#microsoft.graph.identitySet"
			application = @{
				"@odata.type" = "#microsoft.graph.identity"
				displayName = "TestBot"
				id = "dd3885da-f9ab-486b-bfae-85de3d445555"
			}
		}
	}
	targets = @(
		@{
			"@odata.type" = "#microsoft.graph.invitationParticipantInfo"
			identity = @{
				"@odata.type" = "#microsoft.graph.identitySet"
				user = @{
					"@odata.type" = "#microsoft.graph.identity"
					displayName = "user1"
					id = "98da8a1a-1b87-452c-a713-65d3f10b5555"
				}
			}
		}
		@{
			"@odata.type" = "#microsoft.graph.invitationParticipantInfo"
			identity = @{
				"@odata.type" = "#microsoft.graph.identitySet"
				user = @{
					"@odata.type" = "#microsoft.graph.identity"
					displayName = "user2"
					id = "bf5aae9a-d11d-47a8-93b1-782504c95555"
				}
			}
		}
	)
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.appHostedMediaConfig"
		removeFromDefaultAudioGroup = $false
	}
}

New-MgCommunicationCall -BodyParameter $params

```
This example will create a group call with application hosted media

### Example 5: Join scheduled meeting with service hosted media

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	callbackUri = "https://bot.contoso.com/callback"
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.serviceHostedMediaConfig"
		preFetchMedia = @(
		)
	}
	chatInfo = @{
		"@odata.type" = "#microsoft.graph.chatInfo"
		threadId = "19:meeting_Win6Ydo4wsMijFjZS00ZGVjLTk5MGUtOTRjNWY2NmNkYTFm@thread.v2"
		messageId = "0"
	}
	meetingInfo = @{
		"@odata.type" = "#microsoft.graph.organizerMeetingInfo"
		organizer = @{
			"@odata.type" = "#microsoft.graph.identitySet"
			user = @{
				"@odata.type" = "#microsoft.graph.identity"
				id = "5810cede-f3cc-42eb-b2c1-e9bd5d53ec96"
				displayName = "Bob"
				tenantId = "86dc81db-c112-4228-9222-63f3esaa1edb"
			}
		}
		allowConversationWithoutHost = $true
	}
	tenantId = "86dc81db-c112-4228-9222-63f3esaa1edb"
}

New-MgCommunicationCall -BodyParameter $params

```
This example will join scheduled meeting with service hosted media

### Example 6: Join scheduled meeting with application hosted media

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	direction = "outgoing"
	callbackUri = "https://bot.contoso.com/callback"
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.appHostedMediaConfig"
	}
	chatInfo = @{
		"@odata.type" = "#microsoft.graph.chatInfo"
		threadId = "19:meeting_Win6Ydo4wsMijFjZS00ZGVjLTk5MGUtOTRjNWY2NmNkYTFm@thread.v2"
		messageId = "0"
	}
	meetingInfo = @{
		"@odata.type" = "#microsoft.graph.organizerMeetingInfo"
		organizer = @{
			"@odata.type" = "#microsoft.graph.identitySet"
			user = @{
				"@odata.type" = "#microsoft.graph.identity"
				id = "5810cede-f3cc-42eb-b2c1-e9bd5d53ec96"
				tenantId = "aa67bd4c-8475-432d-bd41-39f255720e0a"
				displayName = "Bob"
			}
		}
		allowConversationWithoutHost = $true
	}
	tenantId = "aa67bd4c-8475-432d-bd41-39f255720e0a"
}

New-MgCommunicationCall -BodyParameter $params

```
This example will join scheduled meeting with application hosted media

### Example 7: Join a scheduled meeting with joinMeetingId and passcode

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	callbackUri = "https://bot.contoso.com/callback"
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.serviceHostedMediaConfig"
		preFetchMedia = @(
		)
	}
	meetingInfo = @{
		"@odata.type" = "#microsoft.graph.joinMeetingIdMeetingInfo"
		joinMeetingId = "1234567"
		passcode = "psw123"
	}
	tenantId = "86dc81db-c112-4228-9222-63f3esaa1edb"
}

New-MgCommunicationCall -BodyParameter $params

```
This example will join a scheduled meeting with joinmeetingid and passcode

### Example 8: Join a scheduled meeting with joinMeetingId

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	callbackUri = "https://bot.contoso.com/callback"
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.serviceHostedMediaConfig"
		preFetchMedia = @(
		)
	}
	meetingInfo = @{
		"@odata.type" = "#microsoft.graph.joinMeetingIdMeetingInfo"
		joinMeetingId = "1234567"
		passcode = $null
	}
	tenantId = "86dc81db-c112-4228-9222-63f3esaa1edb"
}

New-MgCommunicationCall -BodyParameter $params

```
This example will join a scheduled meeting with joinmeetingid

### Example 9: Create peer-to-peer PSTN call with service hosted media

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	callbackUri = "https://bot.contoso.com/callback"
	source = @{
		"@odata.type" = "#microsoft.graph.participantInfo"
		identity = @{
			"@odata.type" = "#microsoft.graph.identitySet"
			applicationInstance = @{
				"@odata.type" = "#microsoft.graph.identity"
				displayName = "Calling Bot"
				id = "3d913abb-aec0-4964-8fa6-3c6850c4f278"
			}
		}
		countryCode = $null
		endpointType = $null
		region = $null
		languageId = $null
	}
	targets = @(
		@{
			"@odata.type" = "#microsoft.graph.invitationParticipantInfo"
			identity = @{
				"@odata.type" = "#microsoft.graph.identitySet"
				phone = @{
					"@odata.type" = "#microsoft.graph.identity"
					id = "+12345678901"
				}
			}
		}
	)
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.serviceHostedMediaConfig"
	}
	tenantId = "aa67bd4c-8475-432d-bd41-39f255720e0a"
}

New-MgCommunicationCall -BodyParameter $params

```
This example will create peer-to-peer pstn call with service hosted media

### Example 100: Create peer-to-peer PSTN call with application hosted media

```powershell

Import-Module Microsoft.Graph.CloudCommunications

$params = @{
	"@odata.type" = "#microsoft.graph.call"
	callbackUri = "https://bot.contoso.com/callback"
	source = @{
		"@odata.type" = "#microsoft.graph.participantInfo"
		identity = @{
			"@odata.type" = "#microsoft.graph.identitySet"
			applicationInstance = @{
				"@odata.type" = "#microsoft.graph.identity"
				displayName = "Calling Bot"
				id = "3d913abb-aec0-4964-8fa6-3c6850c4f278"
			}
		}
		countryCode = $null
		endpointType = $null
		region = $null
		languageId = $null
	}
	targets = @(
		@{
			"@odata.type" = "#microsoft.graph.invitationParticipantInfo"
			identity = @{
				"@odata.type" = "#microsoft.graph.identitySet"
				phone = @{
					"@odata.type" = "#microsoft.graph.identity"
					id = "+12345678901"
				}
			}
		}
	)
	requestedModalities = @(
		"audio"
	)
	mediaConfig = @{
		"@odata.type" = "#microsoft.graph.appHostedMediaConfig"
		blob = "<Media Session Configuration>"
	}
	tenantId = "aa67bd4c-8475-432d-bd41-39f255720e0a"
}

New-MgCommunicationCall -BodyParameter $params

```
This example will create peer-to-peer pstn call with application hosted media

