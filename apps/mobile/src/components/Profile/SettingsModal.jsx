import React, { useState } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  Switch,
  Modal,
  TextInput,
  FlatList,
  ActivityIndicator,
  Linking,
  Alert,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { useRouter } from "expo-router";
import {
  Weight,
  Swords,
  Users,
  X,
  User,
  Globe,
  ChevronRight,
  Search,
  Check,
  Dumbbell,
  LogOut,
  Ruler,
  Zap,
  CreditCard,
  Trash2,
} from "lucide-react-native";

const COUNTRIES = [
  "Afghanistan",
  "Albania",
  "Algeria",
  "Andorra",
  "Angola",
  "Antigua and Barbuda",
  "Argentina",
  "Armenia",
  "Australia",
  "Austria",
  "Azerbaijan",
  "Bahamas",
  "Bahrain",
  "Bangladesh",
  "Barbados",
  "Belarus",
  "Belgium",
  "Belize",
  "Benin",
  "Bhutan",
  "Bolivia",
  "Bosnia and Herzegovina",
  "Botswana",
  "Brazil",
  "Brunei",
  "Bulgaria",
  "Burkina Faso",
  "Burundi",
  "Cabo Verde",
  "Cambodia",
  "Cameroon",
  "Canada",
  "Central African Republic",
  "Chad",
  "Chile",
  "China",
  "Colombia",
  "Comoros",
  "Congo",
  "Costa Rica",
  "Croatia",
  "Cuba",
  "Cyprus",
  "Czech Republic",
  "Denmark",
  "Djibouti",
  "Dominica",
  "Dominican Republic",
  "Ecuador",
  "Egypt",
  "El Salvador",
  "Equatorial Guinea",
  "Eritrea",
  "Estonia",
  "Eswatini",
  "Ethiopia",
  "Fiji",
  "Finland",
  "France",
  "Gabon",
  "Gambia",
  "Georgia",
  "Germany",
  "Ghana",
  "Greece",
  "Grenada",
  "Guatemala",
  "Guinea",
  "Guinea-Bissau",
  "Guyana",
  "Haiti",
  "Honduras",
  "Hungary",
  "Iceland",
  "India",
  "Indonesia",
  "Iran",
  "Iraq",
  "Ireland",
  "Israel",
  "Italy",
  "Jamaica",
  "Japan",
  "Jordan",
  "Kazakhstan",
  "Kenya",
  "Kiribati",
  "Kuwait",
  "Kyrgyzstan",
  "Laos",
  "Latvia",
  "Lebanon",
  "Lesotho",
  "Liberia",
  "Libya",
  "Liechtenstein",
  "Lithuania",
  "Luxembourg",
  "Madagascar",
  "Malawi",
  "Malaysia",
  "Maldives",
  "Mali",
  "Malta",
  "Marshall Islands",
  "Mauritania",
  "Mauritius",
  "Mexico",
  "Micronesia",
  "Moldova",
  "Monaco",
  "Mongolia",
  "Montenegro",
  "Morocco",
  "Mozambique",
  "Myanmar",
  "Namibia",
  "Nauru",
  "Nepal",
  "Netherlands",
  "New Zealand",
  "Nicaragua",
  "Niger",
  "Nigeria",
  "North Korea",
  "North Macedonia",
  "Norway",
  "Oman",
  "Pakistan",
  "Palau",
  "Palestine",
  "Panama",
  "Papua New Guinea",
  "Paraguay",
  "Peru",
  "Philippines",
  "Poland",
  "Portugal",
  "Qatar",
  "Romania",
  "Russia",
  "Rwanda",
  "Saint Kitts and Nevis",
  "Saint Lucia",
  "Saint Vincent and the Grenadines",
  "Samoa",
  "San Marino",
  "Sao Tome and Principe",
  "Saudi Arabia",
  "Senegal",
  "Serbia",
  "Seychelles",
  "Sierra Leone",
  "Singapore",
  "Slovakia",
  "Slovenia",
  "Solomon Islands",
  "Somalia",
  "South Africa",
  "South Korea",
  "South Sudan",
  "Spain",
  "Sri Lanka",
  "Sudan",
  "Suriname",
  "Sweden",
  "Switzerland",
  "Syria",
  "Taiwan",
  "Tajikistan",
  "Tanzania",
  "Thailand",
  "Timor-Leste",
  "Togo",
  "Tonga",
  "Trinidad and Tobago",
  "Tunisia",
  "Turkey",
  "Turkmenistan",
  "Tuvalu",
  "Uganda",
  "Ukraine",
  "United Arab Emirates",
  "United Kingdom",
  "United States",
  "Uruguay",
  "Uzbekistan",
  "Vanuatu",
  "Vatican City",
  "Venezuela",
  "Vietnam",
  "Yemen",
  "Zambia",
  "Zimbabwe",
];

function CountryPickerModal({ visible, selectedCountry, onSelect, onClose }) {
  const insets = useSafeAreaInsets();
  const [search, setSearch] = useState("");

  const filtered = COUNTRIES.filter((c) =>
    c.toLowerCase().includes(search.toLowerCase()),
  );

  return (
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View style={{ flex: 1, backgroundColor: "#010308" }}>
        <StatusBar style="light" />

        <View
          style={{
            paddingTop: insets.top + 16,
            paddingHorizontal: 20,
            paddingBottom: 16,
            borderBottomWidth: 1,
            borderBottomColor: "#1A2630",
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <Text
            style={{
              color: "#FFF",
              fontSize: 22,
              fontWeight: "900",
              letterSpacing: 1,
            }}
          >
            SELECT COUNTRY
          </Text>
          <TouchableOpacity
            onPress={onClose}
            style={{
              backgroundColor: "#1A2630",
              borderRadius: 20,
              width: 36,
              height: 36,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <X size={18} color="#888" />
          </TouchableOpacity>
        </View>

        <View style={{ paddingHorizontal: 20, paddingVertical: 12 }}>
          <View
            style={{
              flexDirection: "row",
              alignItems: "center",
              backgroundColor: "#0D1218",
              borderRadius: 12,
              borderWidth: 1,
              borderColor: "#1A2630",
              paddingHorizontal: 14,
              paddingVertical: 10,
              gap: 8,
            }}
          >
            <Search size={16} color="#555" />
            <TextInput
              value={search}
              onChangeText={setSearch}
              placeholder="Search country..."
              placeholderTextColor="#444"
              style={{ flex: 1, color: "#FFF", fontSize: 15 }}
              autoCorrect={false}
            />
            {search.length > 0 && (
              <TouchableOpacity onPress={() => setSearch("")}>
                <X size={14} color="#555" />
              </TouchableOpacity>
            )}
          </View>
        </View>

        <FlatList
          data={filtered}
          keyExtractor={(item) => item}
          keyboardShouldPersistTaps="handled"
          contentContainerStyle={{
            paddingHorizontal: 20,
            paddingBottom: insets.bottom + 24,
          }}
          renderItem={({ item }) => {
            const isSelected = item === selectedCountry;
            return (
              <TouchableOpacity
                onPress={() => {
                  onSelect(item);
                  onClose();
                }}
                style={{
                  flexDirection: "row",
                  alignItems: "center",
                  justifyContent: "space-between",
                  paddingVertical: 14,
                  paddingHorizontal: 16,
                  borderRadius: 12,
                  marginBottom: 4,
                  backgroundColor: isSelected ? "#4BB8FA22" : "transparent",
                  borderWidth: isSelected ? 1 : 0,
                  borderColor: "#4BB8FA55",
                }}
              >
                <Text
                  style={{
                    color: isSelected ? "#4BB8FA" : "#FFF",
                    fontSize: 15,
                    fontWeight: isSelected ? "700" : "400",
                  }}
                >
                  {item}
                </Text>
                {isSelected && <Check size={18} color="#4BB8FA" />}
              </TouchableOpacity>
            );
          }}
        />
      </View>
    </Modal>
  );
}

export function SettingsModal({
  visible,
  onClose,
  settings,
  onUpdateSetting,
  user,
  profile,
  onUpdateCountry,
  isUpdatingCountry,
  onUpdateBodyweight,
  isUpdatingBodyweight,
  onUpdateHeight,
  isUpdatingHeight,
  onSignOut,
  onOpenPaywall,
}) {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const [showCountryPicker, setShowCountryPicker] = useState(false);
  const [bodyweightInput, setBodyweightInput] = useState(
    profile?.bodyweight_kg?.toString() || "",
  );
  const [showBodyweightInput, setShowBodyweightInput] = useState(false);
  const [heightInput, setHeightInput] = useState(
    profile?.height_cm?.toString() || "",
  );
  const [showHeightInput, setShowHeightInput] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [deleteConfirmText, setDeleteConfirmText] = useState("");
  const [isDeleting, setIsDeleting] = useState(false);

  const handleSaveBodyweight = () => {
    const bw = parseFloat(bodyweightInput);
    if (!isNaN(bw) && bw > 0) {
      onUpdateBodyweight(bw);
      setShowBodyweightInput(false);
    }
  };

  const handleSaveHeight = () => {
    const h = parseFloat(heightInput);
    if (!isNaN(h) && h >= 100 && h <= 250) {
      onUpdateHeight(h);
      setShowHeightInput(false);
    }
  };

  const handleSignOut = () => {
    onClose();
    onSignOut();
  };

  const handleNavigateToSubscription = () => {
    onClose();
    router.push("/(tabs)/subscription");
  };

  const handleDeleteAccount = async () => {
    if (deleteConfirmText.trim().toLowerCase() !== "delete my account") {
      Alert.alert(
        "Error",
        "Please type 'delete my account' exactly to confirm.",
      );
      return;
    }

    setIsDeleting(true);
    try {
      const response = await fetch("/api/profile", {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
      });

      if (!response.ok) {
        throw new Error("Failed to delete account");
      }

      // Close all modals
      setShowDeleteModal(false);
      onClose();

      // Redirect to welcome screen
      router.replace("/welcome");
    } catch (error) {
      console.error("Error deleting account:", error);
      Alert.alert("Error", "Failed to delete account. Please try again.");
      setIsDeleting(false);
    }
  };

  return (
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View style={{ flex: 1, backgroundColor: "#010308" }}>
        <StatusBar style="light" />

        <CountryPickerModal
          visible={showCountryPicker}
          selectedCountry={profile?.country}
          onSelect={(country) => onUpdateCountry(country)}
          onClose={() => setShowCountryPicker(false)}
        />

        {/* Delete Account Confirmation Modal */}
        <Modal
          visible={showDeleteModal}
          animationType="fade"
          transparent
          onRequestClose={() => !isDeleting && setShowDeleteModal(false)}
        >
          <View
            style={{
              flex: 1,
              backgroundColor: "rgba(0,0,0,0.85)",
              justifyContent: "center",
              alignItems: "center",
              paddingHorizontal: 24,
            }}
          >
            <View
              style={{
                backgroundColor: "#0D1218",
                borderRadius: 20,
                borderWidth: 1,
                borderColor: "#1A2630",
                padding: 24,
                width: "100%",
                maxWidth: 400,
              }}
            >
              <View
                style={{
                  backgroundColor: "#2A1A1A",
                  width: 64,
                  height: 64,
                  borderRadius: 32,
                  alignItems: "center",
                  justifyContent: "center",
                  alignSelf: "center",
                  marginBottom: 20,
                }}
              >
                <Trash2 size={32} color="#FF4444" />
              </View>

              <Text
                style={{
                  color: "#FFF",
                  fontSize: 22,
                  fontWeight: "900",
                  textAlign: "center",
                  marginBottom: 12,
                }}
              >
                Delete Account?
              </Text>

              <Text
                style={{
                  color: "#888",
                  fontSize: 15,
                  textAlign: "center",
                  marginBottom: 24,
                  lineHeight: 22,
                }}
              >
                This action cannot be undone. All your data, matches,
                achievements, and progress will be permanently deleted.
              </Text>

              <Text
                style={{
                  color: "#FFF",
                  fontSize: 14,
                  fontWeight: "600",
                  marginBottom: 8,
                }}
              >
                Type "delete my account" to confirm:
              </Text>

              <TextInput
                value={deleteConfirmText}
                onChangeText={setDeleteConfirmText}
                placeholder="delete my account"
                placeholderTextColor="#444"
                style={{
                  backgroundColor: "#070D14",
                  borderRadius: 12,
                  borderWidth: 1,
                  borderColor: "#1A2630",
                  padding: 14,
                  color: "#FFF",
                  fontSize: 15,
                  marginBottom: 20,
                }}
                editable={!isDeleting}
                autoCapitalize="none"
                autoCorrect={false}
              />

              <View style={{ flexDirection: "row", gap: 12 }}>
                <TouchableOpacity
                  onPress={() => {
                    setShowDeleteModal(false);
                    setDeleteConfirmText("");
                  }}
                  disabled={isDeleting}
                  style={{
                    flex: 1,
                    backgroundColor: "#1A2630",
                    borderRadius: 12,
                    padding: 16,
                    alignItems: "center",
                  }}
                >
                  <Text
                    style={{
                      color: "#FFF",
                      fontWeight: "700",
                      fontSize: 15,
                    }}
                  >
                    Cancel
                  </Text>
                </TouchableOpacity>

                <TouchableOpacity
                  onPress={handleDeleteAccount}
                  disabled={isDeleting}
                  style={{
                    flex: 1,
                    backgroundColor: "#FF4444",
                    borderRadius: 12,
                    padding: 16,
                    alignItems: "center",
                    opacity: isDeleting ? 0.6 : 1,
                  }}
                >
                  {isDeleting ? (
                    <ActivityIndicator size="small" color="#FFF" />
                  ) : (
                    <Text
                      style={{
                        color: "#FFF",
                        fontWeight: "900",
                        fontSize: 15,
                      }}
                    >
                      DELETE
                    </Text>
                  )}
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </Modal>

        {/* Header */}
        <View
          style={{
            paddingTop: insets.top + 16,
            paddingHorizontal: 20,
            paddingBottom: 16,
            borderBottomWidth: 1,
            borderBottomColor: "#1A2630",
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <Text
            style={{
              color: "#FFF",
              fontSize: 22,
              fontWeight: "900",
              letterSpacing: 1,
            }}
          >
            SETTINGS
          </Text>
          <TouchableOpacity
            onPress={onClose}
            style={{
              backgroundColor: "#1A2630",
              borderRadius: 20,
              width: 36,
              height: 36,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <X size={18} color="#888" />
          </TouchableOpacity>
        </View>

        <ScrollView
          contentContainerStyle={{
            paddingHorizontal: 20,
            paddingTop: 24,
            paddingBottom: insets.bottom + 40,
          }}
          showsVerticalScrollIndicator={false}
        >
          {/* Account */}
          <Text
            style={{
              color: "#555",
              fontSize: 11,
              fontWeight: "700",
              letterSpacing: 1,
              marginBottom: 12,
            }}
          >
            ACCOUNT
          </Text>
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 16,
              borderWidth: 1,
              borderColor: "#1A2630",
              overflow: "hidden",
              marginBottom: 24,
            }}
          >
            <View
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
                borderBottomWidth: 1,
                borderBottomColor: "#1A2630",
              }}
            >
              <View
                style={{
                  backgroundColor: "#1A2630",
                  width: 48,
                  height: 48,
                  borderRadius: 24,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <User size={24} color="#4BB8FA" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 16,
                    fontWeight: "700",
                    marginBottom: 2,
                  }}
                >
                  {user?.email || "User"}
                </Text>
                <Text style={{ color: "#666", fontSize: 13 }}>
                  {profile?.username
                    ? `@${profile.username}`
                    : "No username set"}
                </Text>
              </View>
              <ChevronRight size={20} color="#444" />
            </View>

            <TouchableOpacity
              onPress={handleNavigateToSubscription}
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
              }}
            >
              <View
                style={{
                  backgroundColor: "#1A2630",
                  width: 48,
                  height: 48,
                  borderRadius: 24,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <CreditCard size={24} color="#4BB8FA" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 16,
                    fontWeight: "700",
                    marginBottom: 2,
                  }}
                >
                  Subscription
                </Text>
                <Text style={{ color: "#666", fontSize: 13 }}>
                  Manage your subscription
                </Text>
              </View>
              <ChevronRight size={20} color="#444" />
            </TouchableOpacity>
          </View>

          {/* Region */}
          <Text
            style={{
              color: "#555",
              fontSize: 11,
              fontWeight: "700",
              letterSpacing: 1,
              marginBottom: 12,
            }}
          >
            REGION
          </Text>
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 16,
              borderWidth: 1,
              borderColor: "#1A2630",
              overflow: "hidden",
              marginBottom: 24,
            }}
          >
            <TouchableOpacity
              onPress={() => setShowCountryPicker(true)}
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
              }}
            >
              <View
                style={{
                  backgroundColor: "#1A2630",
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <Globe size={20} color="#4BB8FA" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 2,
                  }}
                >
                  Country
                </Text>
                <Text
                  style={{
                    color: profile?.country ? "#4BB8FA" : "#555",
                    fontSize: 13,
                  }}
                >
                  {profile?.country || "Not set — tap to choose"}
                </Text>
              </View>
              {isUpdatingCountry ? (
                <ActivityIndicator size="small" color="#4BB8FA" />
              ) : (
                <ChevronRight size={20} color="#444" />
              )}
            </TouchableOpacity>
          </View>
          <Text
            style={{
              color: "#444",
              fontSize: 12,
              marginTop: -16,
              marginBottom: 24,
              paddingHorizontal: 4,
            }}
          >
            Used for local leaderboard rankings
          </Text>

          {/* Body Stats */}
          <Text
            style={{
              color: "#555",
              fontSize: 11,
              fontWeight: "700",
              letterSpacing: 1,
              marginBottom: 12,
            }}
          >
            BODY STATS
          </Text>

          {/* Height */}
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 16,
              borderWidth: 1,
              borderColor: "#1A2630",
              overflow: "hidden",
              marginBottom: 12,
            }}
          >
            <TouchableOpacity
              onPress={() => setShowHeightInput(!showHeightInput)}
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
              }}
            >
              <View
                style={{
                  backgroundColor: "#1A2630",
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <Ruler size={20} color="#4BB8FA" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 2,
                  }}
                >
                  Height
                </Text>
                <Text
                  style={{
                    color: profile?.height_cm ? "#4BB8FA" : "#555",
                    fontSize: 13,
                  }}
                >
                  {profile?.height_cm
                    ? `${profile.height_cm} cm`
                    : "Not set — tap to add"}
                </Text>
              </View>
              {isUpdatingHeight ? (
                <ActivityIndicator size="small" color="#4BB8FA" />
              ) : (
                <ChevronRight size={20} color="#444" />
              )}
            </TouchableOpacity>

            {showHeightInput && (
              <View
                style={{
                  padding: 16,
                  borderTopWidth: 1,
                  borderTopColor: "#1A2630",
                }}
              >
                <TextInput
                  value={heightInput}
                  onChangeText={setHeightInput}
                  placeholder="Enter your height in cm (e.g. 175)"
                  placeholderTextColor="#444"
                  keyboardType="numeric"
                  style={{
                    backgroundColor: "#070D14",
                    borderRadius: 10,
                    padding: 12,
                    color: "#FFF",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 10,
                  }}
                />
                <TouchableOpacity
                  onPress={handleSaveHeight}
                  style={{
                    backgroundColor: "#4BB8FA",
                    borderRadius: 10,
                    padding: 12,
                    alignItems: "center",
                  }}
                >
                  <Text
                    style={{ color: "#000", fontWeight: "900", fontSize: 14 }}
                  >
                    SAVE
                  </Text>
                </TouchableOpacity>
              </View>
            )}
          </View>

          {/* Bodyweight */}
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 16,
              borderWidth: 1,
              borderColor: "#1A2630",
              overflow: "hidden",
              marginBottom: 24,
            }}
          >
            <TouchableOpacity
              onPress={() => setShowBodyweightInput(!showBodyweightInput)}
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
              }}
            >
              <View
                style={{
                  backgroundColor: "#1A2630",
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <Weight size={20} color="#4BB8FA" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 2,
                  }}
                >
                  Bodyweight
                </Text>
                <Text
                  style={{
                    color: profile?.bodyweight_kg ? "#4BB8FA" : "#555",
                    fontSize: 13,
                  }}
                >
                  {profile?.bodyweight_kg
                    ? `${profile.bodyweight_kg} kg`
                    : "Not set — tap to add"}
                </Text>
              </View>
              {isUpdatingBodyweight ? (
                <ActivityIndicator size="small" color="#4BB8FA" />
              ) : (
                <ChevronRight size={20} color="#444" />
              )}
            </TouchableOpacity>

            {showBodyweightInput && (
              <View
                style={{
                  padding: 16,
                  borderTopWidth: 1,
                  borderTopColor: "#1A2630",
                }}
              >
                <TextInput
                  value={bodyweightInput}
                  onChangeText={setBodyweightInput}
                  placeholder="Enter your bodyweight (kg)"
                  placeholderTextColor="#444"
                  keyboardType="numeric"
                  style={{
                    backgroundColor: "#070D14",
                    borderRadius: 10,
                    padding: 12,
                    color: "#FFF",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 10,
                  }}
                />
                <TouchableOpacity
                  onPress={handleSaveBodyweight}
                  style={{
                    backgroundColor: "#4BB8FA",
                    borderRadius: 10,
                    padding: 12,
                    alignItems: "center",
                  }}
                >
                  <Text
                    style={{ color: "#000", fontWeight: "900", fontSize: 14 }}
                  >
                    SAVE
                  </Text>
                </TouchableOpacity>
              </View>
            )}
          </View>

          {/* Preferences */}
          <Text
            style={{
              color: "#555",
              fontSize: 11,
              fontWeight: "700",
              letterSpacing: 1,
              marginBottom: 12,
            }}
          >
            PREFERENCES
          </Text>
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 20,
              borderWidth: 1,
              borderColor: "#1A2630",
              overflow: "hidden",
              marginBottom: 28,
            }}
          >
            {/* Weight Units */}
            <View
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
                borderBottomWidth: 1,
                borderBottomColor: "#1A2630",
              }}
            >
              <View
                style={{
                  backgroundColor: "#1A2630",
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <Dumbbell size={20} color="#4BB8FA" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 2,
                  }}
                >
                  Weight Units
                </Text>
                <Text style={{ color: "#555", fontSize: 12 }}>
                  Used across workouts and stats
                </Text>
              </View>
              <View style={{ flexDirection: "row", gap: 8 }}>
                {["kg", "lbs"].map((unit) => {
                  const isActive = (settings?.units ?? "kg") === unit;
                  return (
                    <TouchableOpacity
                      key={unit}
                      onPress={() => onUpdateSetting({ units: unit })}
                      style={{
                        paddingHorizontal: 14,
                        paddingVertical: 7,
                        borderRadius: 10,
                        backgroundColor: isActive ? "#4BB8FA" : "#1A2630",
                        borderWidth: 1,
                        borderColor: isActive ? "#4BB8FA" : "#2A3640",
                      }}
                    >
                      <Text
                        style={{
                          color: isActive ? "#000" : "#888",
                          fontWeight: "800",
                          fontSize: 13,
                        }}
                      >
                        {unit}
                      </Text>
                    </TouchableOpacity>
                  );
                })}
              </View>
            </View>

            {/* Match Invites */}
            <View
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
                borderBottomWidth: 1,
                borderBottomColor: "#1A2630",
              }}
            >
              <View
                style={{
                  backgroundColor: "#1A2630",
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <Swords size={20} color="#4BB8FA" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 2,
                  }}
                >
                  Match Invites
                </Text>
                <Text style={{ color: "#555", fontSize: 12 }}>
                  Allow others to challenge you
                </Text>
              </View>
              <Switch
                value={settings?.allow_match_invites ?? true}
                onValueChange={(v) =>
                  onUpdateSetting({ allow_match_invites: v })
                }
                trackColor={{ false: "#1A2630", true: "#4BB8FA" }}
                thumbColor="#FFF"
              />
            </View>

            {/* Friend Requests */}
            <View
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
              }}
            >
              <View
                style={{
                  backgroundColor: "#1A2630",
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <Users size={20} color="#4BB8FA" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 2,
                  }}
                >
                  Friend Requests
                </Text>
                <Text style={{ color: "#555", fontSize: 12 }}>
                  Allow others to add you
                </Text>
              </View>
              <Switch
                value={settings?.allow_friend_requests ?? true}
                onValueChange={(v) =>
                  onUpdateSetting({ allow_friend_requests: v })
                }
                trackColor={{ false: "#1A2630", true: "#4BB8FA" }}
                thumbColor="#FFF"
              />
            </View>
          </View>

          {/* Sign Out Section */}
          <Text
            style={{
              color: "#555",
              fontSize: 11,
              fontWeight: "700",
              letterSpacing: 1,
              marginBottom: 12,
            }}
          >
            ACCOUNT ACTIONS
          </Text>
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 16,
              borderWidth: 1,
              borderColor: "#1A2630",
              overflow: "hidden",
              marginBottom: 24,
            }}
          >
            <TouchableOpacity
              onPress={handleSignOut}
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
                borderBottomWidth: 1,
                borderBottomColor: "#1A2630",
              }}
            >
              <View
                style={{
                  backgroundColor: "#2A1A1A",
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <LogOut size={20} color="#FF4444" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FF4444",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 2,
                  }}
                >
                  Sign Out
                </Text>
                <Text style={{ color: "#555", fontSize: 12 }}>
                  Exit your account on this device
                </Text>
              </View>
              <ChevronRight size={20} color="#444" />
            </TouchableOpacity>

            <TouchableOpacity
              onPress={() => setShowDeleteModal(true)}
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
              }}
            >
              <View
                style={{
                  backgroundColor: "#2A1A1A",
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  marginRight: 12,
                }}
              >
                <Trash2 size={20} color="#FF4444" />
              </View>
              <View style={{ flex: 1 }}>
                <Text
                  style={{
                    color: "#FF4444",
                    fontSize: 15,
                    fontWeight: "600",
                    marginBottom: 2,
                  }}
                >
                  Delete Account
                </Text>
                <Text style={{ color: "#555", fontSize: 12 }}>
                  Permanently remove your account and data
                </Text>
              </View>
              <ChevronRight size={20} color="#444" />
            </TouchableOpacity>
          </View>

          {/* Legal */}
          <Text
            style={{
              color: "#555",
              fontSize: 11,
              fontWeight: "700",
              letterSpacing: 1,
              marginBottom: 12,
            }}
          >
            LEGAL
          </Text>
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 16,
              borderWidth: 1,
              borderColor: "#1A2630",
              overflow: "hidden",
              marginBottom: 24,
            }}
          >
            <TouchableOpacity
              onPress={() => Linking.openURL("https://www.outrepd.com/privacy")}
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
                borderBottomWidth: 1,
                borderBottomColor: "#1A2630",
              }}
            >
              <View style={{ flex: 1 }}>
                <Text
                  style={{ color: "#FFF", fontSize: 15, fontWeight: "600" }}
                >
                  Privacy Policy
                </Text>
              </View>
              <ChevronRight size={20} color="#444" />
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => Linking.openURL("https://www.outrepd.com/terms")}
              style={{
                flexDirection: "row",
                alignItems: "center",
                padding: 16,
              }}
            >
              <View style={{ flex: 1 }}>
                <Text
                  style={{ color: "#FFF", fontSize: 15, fontWeight: "600" }}
                >
                  Terms of Service
                </Text>
              </View>
              <ChevronRight size={20} color="#444" />
            </TouchableOpacity>
          </View>
        </ScrollView>
      </View>
    </Modal>
  );
}
