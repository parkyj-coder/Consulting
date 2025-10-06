package model;

import java.sql.Timestamp;

public class ConsultationRequest {
    private int id;
    private String companyName;
    private String businessNumber;
    private String applicantName;
    private String relationship;
    private String relationshipOther;
    private String phone;
    private String address;
    private String detailAddress;
    private String ownership;
    private String industry;
    private String sales;
    private String salesUnit;
    private String loanAmount;
    private String loanUnit;
    private String fundType;
    private String message;
    private boolean privacyAgreement;
    private Timestamp createdAt;
    private String status;
    
    // 기본 생성자
    public ConsultationRequest() {}
    
    // 생성자
    public ConsultationRequest(String companyName, String businessNumber, String applicantName,
                             String relationship, String relationshipOther, String phone,
                             String address, String detailAddress, String ownership,
                             String industry, String sales, String salesUnit, String loanAmount, String loanUnit,
                             String fundType, String message, boolean privacyAgreement) {
        this.companyName = companyName;
        this.businessNumber = businessNumber;
        this.applicantName = applicantName;
        this.relationship = relationship;
        this.relationshipOther = relationshipOther;
        this.phone = phone;
        this.address = address;
        this.detailAddress = detailAddress;
        this.ownership = ownership;
        this.industry = industry;
        this.sales = sales;
        this.salesUnit = salesUnit;
        this.loanAmount = loanAmount;
        this.loanUnit = loanUnit;
        this.fundType = fundType;
        this.message = message;
        this.privacyAgreement = privacyAgreement;
        this.status = "대기중";
    }
    
    // Getter와 Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    
    public String getBusinessNumber() { return businessNumber; }
    public void setBusinessNumber(String businessNumber) { this.businessNumber = businessNumber; }
    
    public String getApplicantName() { return applicantName; }
    public void setApplicantName(String applicantName) { this.applicantName = applicantName; }
    
    public String getRelationship() { return relationship; }
    public void setRelationship(String relationship) { this.relationship = relationship; }
    
    public String getRelationshipOther() { return relationshipOther; }
    public void setRelationshipOther(String relationshipOther) { this.relationshipOther = relationshipOther; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getDetailAddress() { return detailAddress; }
    public void setDetailAddress(String detailAddress) { this.detailAddress = detailAddress; }
    
    public String getOwnership() { return ownership; }
    public void setOwnership(String ownership) { this.ownership = ownership; }
    
    public String getIndustry() { return industry; }
    public void setIndustry(String industry) { this.industry = industry; }
    
    public String getSales() { return sales; }
    public void setSales(String sales) { this.sales = sales; }
    
    public String getSalesUnit() { return salesUnit; }
    public void setSalesUnit(String salesUnit) { this.salesUnit = salesUnit; }
    
    public String getLoanAmount() { return loanAmount; }
    public void setLoanAmount(String loanAmount) { this.loanAmount = loanAmount; }
    
    public String getLoanUnit() { return loanUnit; }
    public void setLoanUnit(String loanUnit) { this.loanUnit = loanUnit; }
    
    public String getFundType() { return fundType; }
    public void setFundType(String fundType) { this.fundType = fundType; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public boolean isPrivacyAgreement() { return privacyAgreement; }
    public void setPrivacyAgreement(boolean privacyAgreement) { this.privacyAgreement = privacyAgreement; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
