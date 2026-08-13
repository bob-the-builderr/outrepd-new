import React, { useState, useEffect } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  TextInput,
  ActivityIndicator,
  Alert,
  Modal,
} from "react-native";
import { Image } from "expo-image";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { Users, Search, Plus, Swords, X, Check } from "lucide-react-native";
import { TIERS, DIVISION_NAMES } from "@/constants/tiers";
import { useAuth } from "@/utils/auth/useAuth";
import { getApiUrl } from "@/utils/getApiUrl";
import { authenticatedFetch } from "@/utils/authenticatedFetch";
import { ProfileFrame } from "@/components/ProfileFrame";
import { UserProfileModal } from "@/components/Profile/UserProfileModal";

export default function FriendsScreen() {
  const insets = useSafeAreaInsets();
  const { auth, isReady, signIn } = useAuth();
  const [friends, setFriends] = useState([]);
  const [incomingRequests, setIncomingRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [searchResults, setSearchResults] = useState([]);
  const [searchLoading, setSearchLoading] = useState(false);
  const [searchError, setSearchError] = useState(null);
  const [sendingRequest, setSendingRequest] = useState(null);
  const [selectedUserId, setSelectedUserId] = useState(null);
  const [showIncomingModal, setShowIncomingModal] = useState(false);

  useEffect(() => {
    if (auth) {
      fetchFriends();
    } else {
      setLoading(false);
    }
  }, [auth]);

  // Search for users as the user types
  useEffect(() => {
    const timer = setTimeout(() => {
      if (searchQuery.trim().length > 0) {
        searchUsers();
      } else {
        setSearchResults([]);
        setSearchError(null);
      }
    }, 300);

    return () => clearTimeout(timer);
  }, [searchQuery]);

  const fetchFriends = async () => {
    try {
      setLoading(true);
      const response = await authenticatedFetch("/api/friends");
      if (!response.ok) throw new Error("Failed to fetch friends");
      const data = await response.json();
      setFriends(data.friends || []);
      setIncomingRequests(data.incoming_requests || []);
    } catch (error) {
      console.error("Error fetching friends:", error);
    } finally {
      setLoading(false);
    }
  };

  const searchUsers = async () => {
    try {
      setSearchLoading(true);
      setSearchError(null);
      const response = await authenticatedFetch(
        `/api/user-search?q=${encodeURIComponent(searchQuery.trim())}`,
      );
      if (!response.ok) {
        const errData = await response.json().catch(() => ({}));
        throw new Error(errData.error || `Search failed (${response.status})`);
      }
      const data = await response.json();
      setSearchResults(data.users || []);
    } catch (error) {
      console.error("Error searching users:", error);
      setSearchError(error.message || "Search failed");
      setSearchResults([]);
    } finally {
      setSearchLoading(false);
    }
  };

  const sendFriendRequest = async (username, userId) => {
    try {
      setSendingRequest(userId);
      const response = await authenticatedFetch("/api/friends", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username }),
      });

      const data = await response.json();

      if (!response.ok) {
        Alert.alert("Error", data.error || "Failed to send friend request");
        return;
      }

      Alert.alert("Success", data.message || "Friend request sent!");
      // Update the search results to show pending status
      setSearchResults((prev) =>
        prev.map((user) =>
          user.user_id === userId
            ? { ...user, friendship_status: "pending" }
            : user,
        ),
      );
    } catch (error) {
      console.error("Error sending friend request:", error);
      Alert.alert("Error", "Something went wrong");
    } finally {
      setSendingRequest(null);
    }
  };

  const respondToRequest = async (friendshipId, action) => {
    try {
      const response = await authenticatedFetch("/api/friends", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ friendship_id: friendshipId, action }),
      });

      const data = await response.json();

      if (!response.ok) {
        Alert.alert("Error", data.error || "Failed to respond to request");
        return;
      }

      Alert.alert("Success", data.message);
      fetchFriends(); // Refresh the lists
    } catch (error) {
      console.error("Error responding to request:", error);
      Alert.alert("Error", "Something went wrong");
    }
  };

  const removeFriend = async (friendId, username) => {
    Alert.alert("Remove Friend", `Remove ${username} from your friends?`, [
      { text: "Cancel", style: "cancel" },
      {
        text: "Remove",
        style: "destructive",
        onPress: async () => {
          try {
            const response = await authenticatedFetch("/api/friends", {
              method: "DELETE",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ friend_id: friendId }),
            });

            const data = await response.json();

            if (!response.ok) {
              Alert.alert("Error", data.error || "Failed to remove friend");
              return;
            }

            Alert.alert("Success", data.message);
            fetchFriends();
          } catch (error) {
            console.error("Error removing friend:", error);
            Alert.alert("Error", "Something went wrong");
          }
        },
      },
    ]);
  };

  const viewFriendProfile = (friend) => {
    setSelectedUserId(friend.user_id);
  };

  const challengeFriend = async (friend) => {
    Alert.alert(
      "Challenge Friend",
      `Create a match invite for ${friend.username}?`,
      [
        { text: "Cancel", style: "cancel" },
        {
          text: "Create Match",
          onPress: async () => {
            try {
              // Get current user profile to get tier/div/lp
              const profileRes = await authenticatedFetch("/api/profile");
              const profileData = await profileRes.json();
              const profile = profileData.profile;

              // Create a match invite (user will need to select muscle group)
              // For now, we'll just create an invite and show the code
              const response = await authenticatedFetch("/api/matches/invite", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                  muscle_group: "Chest", // Default for now
                  tier_idx: profile.tier_idx,
                  div_idx: profile.div_idx,
                  lp: profile.lp,
                  demotion_shield: profile.demotion_shield,
                }),
              });

              const data = await response.json();

              if (!response.ok) {
                Alert.alert("Error", data.error || "Failed to create match");
                return;
              }

              Alert.alert(
                "Match Created!",
                `Share this code with ${friend.username}: ${data.invite_code}`,
                [{ text: "OK" }],
              );
            } catch (error) {
              console.error("Error creating match:", error);
              Alert.alert("Error", "Failed to create match");
            }
          },
        },
      ],
    );
  };

  const renderFriendButton = (user) => {
    const status = user.friendship_status;

    if (status === "accepted") {
      return (
        <View
          style={{
            backgroundColor: "#00C85322",
            paddingHorizontal: 12,
            paddingVertical: 6,
            borderRadius: 8,
          }}
        >
          <Text style={{ color: "#00C853", fontWeight: "bold", fontSize: 12 }}>
            Friends
          </Text>
        </View>
      );
    }

    if (status === "pending") {
      return (
        <View
          style={{
            backgroundColor: "#FFA50022",
            paddingHorizontal: 12,
            paddingVertical: 6,
            borderRadius: 8,
          }}
        >
          <Text style={{ color: "#FFA500", fontWeight: "bold", fontSize: 12 }}>
            Pending
          </Text>
        </View>
      );
    }

    // No friendship - show add button
    return (
      <TouchableOpacity
        onPress={() => sendFriendRequest(user.username, user.user_id)}
        disabled={sendingRequest === user.user_id}
        style={{
          backgroundColor: "#4BB8FA",
          padding: 8,
          borderRadius: 8,
        }}
      >
        {sendingRequest === user.user_id ? (
          <ActivityIndicator size="small" color="#000" />
        ) : (
          <Plus color="#000" size={20} />
        )}
      </TouchableOpacity>
    );
  };

  if (!isReady || loading) {
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#0D0D0D",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <ActivityIndicator size="large" color="#4BB8FA" />
      </View>
    );
  }

  // Guest state
  if (!auth) {
    return (
      <View style={{ flex: 1, backgroundColor: "#0D0D0D" }}>
        <View
          style={{
            paddingTop: insets.top + 20,
            paddingHorizontal: 20,
            paddingBottom: 10,
          }}
        >
          <Text style={{ color: "#FFF", fontSize: 32, fontWeight: "900" }}>
            FRIENDS
          </Text>
          <Text style={{ color: "#888", fontWeight: "bold" }}>
            Challenge your crew to battles
          </Text>
        </View>

        <View
          style={{
            flex: 1,
            justifyContent: "center",
            alignItems: "center",
            paddingHorizontal: 32,
          }}
        >
          <Users size={64} color="#444" style={{ marginBottom: 24 }} />
          <Text
            style={{
              fontSize: 20,
              fontWeight: "700",
              color: "#fff",
              marginBottom: 8,
              textAlign: "center",
            }}
          >
            Connect with Friends
          </Text>
          <Text
            style={{
              fontSize: 14,
              color: "#888",
              marginBottom: 24,
              textAlign: "center",
            }}
          >
            Sign in to add friends, challenge them to matches, and track your
            rivalries
          </Text>
          <TouchableOpacity
            onPress={() => signIn()}
            style={{
              backgroundColor: "#4BB8FA",
              paddingHorizontal: 32,
              paddingVertical: 12,
              borderRadius: 10,
            }}
          >
            <Text style={{ fontSize: 16, fontWeight: "700", color: "#000" }}>
              SIGN IN
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: "#0D0D0D" }}>
      {/* UserProfileModal for viewing friend profiles */}
      <UserProfileModal
        visible={!!selectedUserId}
        onClose={() => setSelectedUserId(null)}
        userId={selectedUserId}
      />

      <View
        style={{
          paddingTop: insets.top + 20,
          paddingHorizontal: 20,
          paddingBottom: 10,
        }}
      >
        <Text style={{ color: "#FFF", fontSize: 32, fontWeight: "900" }}>
          FRIENDS
        </Text>
        <Text style={{ color: "#888", fontWeight: "bold" }}>
          Challenge your crew to battles
        </Text>
      </View>

      {/* Search Bar */}
      <View style={{ paddingHorizontal: 20, marginBottom: 16 }}>
        <View
          style={{
            backgroundColor: "#1A1A1A",
            borderRadius: 16,
            flexDirection: "row",
            alignItems: "center",
            paddingHorizontal: 16,
            paddingVertical: 12,
            borderWidth: 1,
            borderColor: "#333",
          }}
        >
          <Search color="#666" size={20} />
          <TextInput
            style={{
              flex: 1,
              color: "#FFF",
              fontSize: 16,
              paddingHorizontal: 12,
            }}
            placeholder="Search by username..."
            placeholderTextColor="#666"
            value={searchQuery}
            onChangeText={setSearchQuery}
            autoCapitalize="none"
          />
        </View>

        {/* Search Results Dropdown */}
        {searchQuery.trim().length > 0 && (
          <View
            style={{
              backgroundColor: "#1A1A1A",
              borderRadius: 16,
              marginTop: 8,
              borderWidth: 1,
              borderColor: "#333",
              maxHeight: 300,
            }}
          >
            {searchLoading ? (
              <View style={{ padding: 20, alignItems: "center" }}>
                <ActivityIndicator size="small" color="#4BB8FA" />
              </View>
            ) : searchError ? (
              <View style={{ padding: 20, alignItems: "center" }}>
                <Text
                  style={{
                    color: "#FF4444",
                    fontWeight: "bold",
                    fontSize: 12,
                    textAlign: "center",
                  }}
                >
                  {searchError}
                </Text>
              </View>
            ) : searchResults.length === 0 ? (
              <View style={{ padding: 20, alignItems: "center" }}>
                <Text style={{ color: "#666", fontWeight: "bold" }}>
                  No users found
                </Text>
              </View>
            ) : (
              <ScrollView>
                {searchResults.map((user) => {
                  const tier =
                    TIERS[Math.min(user.tier_idx || 0, TIERS.length - 1)] ||
                    TIERS[0];
                  const division =
                    DIVISION_NAMES[Math.min(user.div_idx || 0, 3)] || "IV";

                  return (
                    <View
                      key={user.user_id}
                      style={{
                        flexDirection: "row",
                        alignItems: "center",
                        padding: 16,
                        borderBottomWidth: 1,
                        borderBottomColor: "#333",
                      }}
                    >
                      <ProfileFrame
                        size={50}
                        tierIdx={user.tier_idx || 0}
                        photoUrl={user.profile_photo_url}
                        fallbackIcon={tier.icon}
                        glow={false}
                      />
                      <View style={{ flex: 1, marginLeft: 12 }}>
                        <Text
                          style={{
                            color: "#FFF",
                            fontWeight: "bold",
                            fontSize: 16,
                          }}
                        >
                          {user.username}
                        </Text>
                        <View
                          style={{
                            backgroundColor: "#222",
                            paddingHorizontal: 10,
                            paddingVertical: 4,
                            borderRadius: 8,
                            alignSelf: "flex-start",
                            marginTop: 4,
                          }}
                        >
                          <Text
                            style={{
                              color: "#4BB8FA",
                              fontWeight: "bold",
                              fontSize: 11,
                            }}
                          >
                            {tier.name} {division}
                          </Text>
                        </View>
                      </View>
                      {renderFriendButton(user)}
                    </View>
                  );
                })}
              </ScrollView>
            )}
          </View>
        )}
      </View>

      {loading ? (
        <View
          style={{ flex: 1, justifyContent: "center", alignItems: "center" }}
        >
          <ActivityIndicator size="large" color="#4BB8FA" />
        </View>
      ) : (
        <ScrollView
          contentContainerStyle={{
            padding: 20,
            paddingBottom: insets.bottom + 100,
          }}
        >
          {/* Incoming Requests Button */}
          <TouchableOpacity
            onPress={() => setShowIncomingModal(true)}
            style={{
              marginBottom: 24,
            }}
          >
            <View
              style={{ flexDirection: "row", alignItems: "center", gap: 12 }}
            >
              <View
                style={{
                  backgroundColor: "#4BB8FA",
                  paddingHorizontal: 24,
                  paddingVertical: 14,
                  borderRadius: 16,
                  flexDirection: "row",
                  alignItems: "center",
                  gap: 8,
                }}
              >
                <Text
                  style={{
                    color: "#000",
                    fontWeight: "900",
                    fontSize: 16,
                  }}
                >
                  Incoming Requests
                </Text>
                {incomingRequests.length > 0 && (
                  <Text
                    style={{
                      color: "#4BB8FA",
                      fontWeight: "900",
                      fontSize: 16,
                    }}
                  >
                    (*)
                  </Text>
                )}
              </View>
              {incomingRequests.length > 0 && (
                <View
                  style={{
                    backgroundColor: "#FF4444",
                    borderRadius: 12,
                    paddingHorizontal: 10,
                    paddingVertical: 6,
                  }}
                >
                  <Text
                    style={{ color: "#FFF", fontWeight: "900", fontSize: 14 }}
                  >
                    {incomingRequests.length}
                  </Text>
                </View>
              )}
            </View>
          </TouchableOpacity>

          {/* Friends List */}
          {friends.length === 0 && incomingRequests.length === 0 ? (
            <View style={{ alignItems: "center", marginTop: 100 }}>
              <Users color="#333" size={64} />
              <Text
                style={{
                  color: "#888",
                  fontWeight: "bold",
                  marginTop: 20,
                  textAlign: "center",
                }}
              >
                No friends yet. Search for users to add! 💪
              </Text>
            </View>
          ) : friends.length > 0 ? (
            <>
              <Text
                style={{
                  color: "#FFF",
                  fontWeight: "900",
                  fontSize: 16,
                  marginBottom: 12,
                }}
              >
                YOUR FRIENDS
              </Text>
              {friends.map((friend) => {
                const tier =
                  TIERS[Math.min(friend.tier_idx || 0, TIERS.length - 1)] ||
                  TIERS[0];
                const division =
                  DIVISION_NAMES[Math.min(friend.div_idx || 0, 3)] || "IV";

                return (
                  <TouchableOpacity
                    key={friend.friendship_id}
                    activeOpacity={0.9}
                    onPress={() => viewFriendProfile(friend)}
                    onLongPress={() =>
                      removeFriend(friend.user_id, friend.username)
                    }
                    style={{
                      backgroundColor: "#1A1A1A",
                      borderRadius: 24,
                      padding: 20,
                      marginBottom: 16,
                      borderWidth: 1,
                      borderColor: "#333",
                    }}
                  >
                    <View
                      style={{
                        flexDirection: "row",
                        alignItems: "center",
                        gap: 12,
                      }}
                    >
                      <ProfileFrame
                        size={60}
                        tierIdx={friend.tier_idx || 0}
                        photoUrl={friend.profile_photo_url}
                        fallbackIcon={tier.icon}
                        glow={false}
                      />
                      <View style={{ flex: 1 }}>
                        <Text
                          style={{
                            color: "#FFF",
                            fontWeight: "bold",
                            fontSize: 18,
                            marginBottom: 4,
                          }}
                        >
                          {friend.username}
                        </Text>
                        <View
                          style={{
                            backgroundColor: "#222",
                            paddingHorizontal: 12,
                            paddingVertical: 4,
                            borderRadius: 8,
                            alignSelf: "flex-start",
                          }}
                        >
                          <Text
                            style={{
                              color: "#4BB8FA",
                              fontWeight: "bold",
                              fontSize: 12,
                            }}
                          >
                            {tier.name} {division}
                          </Text>
                        </View>
                      </View>
                      <View style={{ alignItems: "flex-end" }}>
                        <Text
                          style={{
                            color: "#888",
                            fontSize: 12,
                            fontWeight: "bold",
                          }}
                        >
                          {friend.lp} LP
                        </Text>
                        <View
                          style={{
                            flexDirection: "row",
                            gap: 8,
                            marginTop: 4,
                          }}
                        >
                          <Text
                            style={{
                              color: "#00C853",
                              fontWeight: "bold",
                              fontSize: 12,
                            }}
                          >
                            {friend.wins}W
                          </Text>
                          <Text
                            style={{
                              color: "#FF4444",
                              fontWeight: "bold",
                              fontSize: 12,
                            }}
                          >
                            {friend.losses}L
                          </Text>
                        </View>
                      </View>
                    </View>

                    {/* Match Record vs This Friend */}
                    {(friend.wins_against_friend > 0 ||
                      friend.losses_against_friend > 0) && (
                      <View
                        style={{
                          marginTop: 16,
                          paddingTop: 16,
                          borderTopWidth: 1,
                          borderTopColor: "#333",
                          flexDirection: "row",
                          justifyContent: "space-around",
                        }}
                      >
                        <View style={{ alignItems: "center" }}>
                          <Text
                            style={{
                              color: "#666",
                              fontSize: 10,
                              fontWeight: "bold",
                            }}
                          >
                            VS RECORD
                          </Text>
                          <Text
                            style={{
                              color: "#FFF",
                              fontWeight: "900",
                              marginTop: 4,
                            }}
                          >
                            <Text style={{ color: "#00C853" }}>
                              {friend.wins_against_friend}
                            </Text>
                            {" - "}
                            <Text style={{ color: "#FF4444" }}>
                              {friend.losses_against_friend}
                            </Text>
                          </Text>
                        </View>
                      </View>
                    )}
                  </TouchableOpacity>
                );
              })}
            </>
          ) : null}
        </ScrollView>
      )}

      {/* Incoming Requests Modal */}
      <Modal
        visible={showIncomingModal}
        animationType="slide"
        presentationStyle="fullScreen"
        onRequestClose={() => setShowIncomingModal(false)}
      >
        <View
          style={{
            flex: 1,
            backgroundColor: "#0D0D0D",
          }}
        >
          <View
            style={{
              flex: 1,
            }}
          >
            {/* Modal Header */}
            <View
              style={{
                paddingTop: insets.top + 20,
                flexDirection: "row",
                alignItems: "center",
                justifyContent: "space-between",
                paddingHorizontal: 20,
                paddingBottom: 20,
                borderBottomWidth: 1,
                borderBottomColor: "#333",
              }}
            >
              <Text
                style={{
                  color: "#FFF",
                  fontSize: 24,
                  fontWeight: "900",
                }}
              >
                INCOMING REQUESTS
              </Text>
              <TouchableOpacity onPress={() => setShowIncomingModal(false)}>
                <X color="#FFF" size={28} />
              </TouchableOpacity>
            </View>

            {/* Modal Content */}
            <ScrollView
              contentContainerStyle={{
                padding: 20,
                paddingBottom: insets.bottom + 20,
              }}
            >
              {incomingRequests.length === 0 ? (
                <View style={{ alignItems: "center", paddingVertical: 40 }}>
                  <Users color="#333" size={64} />
                  <Text
                    style={{
                      color: "#666",
                      fontWeight: "bold",
                      marginTop: 16,
                      textAlign: "center",
                    }}
                  >
                    No pending requests
                  </Text>
                </View>
              ) : (
                incomingRequests.map((request) => {
                  const tier =
                    TIERS[Math.min(request.tier_idx || 0, TIERS.length - 1)] ||
                    TIERS[0];
                  const division =
                    DIVISION_NAMES[Math.min(request.div_idx || 0, 3)] || "IV";

                  return (
                    <View
                      key={request.friendship_id}
                      style={{
                        backgroundColor: "#1A1A1A",
                        borderRadius: 24,
                        padding: 16,
                        marginBottom: 12,
                        borderWidth: 1,
                        borderColor: "#4BB8FA44",
                      }}
                    >
                      <View
                        style={{
                          flexDirection: "row",
                          alignItems: "center",
                          marginBottom: 12,
                        }}
                      >
                        <ProfileFrame
                          size={50}
                          tierIdx={request.tier_idx || 0}
                          photoUrl={request.profile_photo_url}
                          fallbackIcon={tier.icon}
                          glow={false}
                        />
                        <View style={{ flex: 1, marginLeft: 12 }}>
                          <Text
                            style={{
                              color: "#FFF",
                              fontWeight: "bold",
                              fontSize: 16,
                            }}
                          >
                            {request.username}
                          </Text>
                          <View
                            style={{
                              backgroundColor: "#222",
                              paddingHorizontal: 10,
                              paddingVertical: 4,
                              borderRadius: 8,
                              alignSelf: "flex-start",
                              marginTop: 4,
                            }}
                          >
                            <Text
                              style={{
                                color: "#4BB8FA",
                                fontWeight: "bold",
                                fontSize: 11,
                              }}
                            >
                              {tier.name} {division}
                            </Text>
                          </View>
                        </View>
                      </View>
                      <View style={{ flexDirection: "row", gap: 12 }}>
                        <TouchableOpacity
                          onPress={() => {
                            respondToRequest(request.friendship_id, "accept");
                            setShowIncomingModal(false);
                          }}
                          style={{
                            flex: 1,
                            backgroundColor: "#00C853",
                            paddingVertical: 12,
                            borderRadius: 12,
                            flexDirection: "row",
                            alignItems: "center",
                            justifyContent: "center",
                            gap: 6,
                          }}
                        >
                          <Check color="#000" size={18} />
                          <Text style={{ color: "#000", fontWeight: "900" }}>
                            Accept
                          </Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                          onPress={() => {
                            respondToRequest(request.friendship_id, "reject");
                            setShowIncomingModal(false);
                          }}
                          style={{
                            flex: 1,
                            backgroundColor: "#FF4444",
                            paddingVertical: 12,
                            borderRadius: 12,
                            flexDirection: "row",
                            alignItems: "center",
                            justifyContent: "center",
                            gap: 6,
                          }}
                        >
                          <X color="#000" size={18} />
                          <Text style={{ color: "#000", fontWeight: "900" }}>
                            Decline
                          </Text>
                        </TouchableOpacity>
                      </View>
                    </View>
                  );
                })
              )}
            </ScrollView>
          </View>
        </View>
      </Modal>
    </View>
  );
}
