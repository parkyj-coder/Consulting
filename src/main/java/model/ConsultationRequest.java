package model;

import java.sql.Timestamp;

public class ConsultationRequest {
    private int id;
    private String companyName;
    private String businessNumber;
    private String contactName;
    private String relationship;
    private String relationshipOther;
    private String phone;
    private String address;
    private String detailAddress;
    private String ownership;
    private String industry;
    private String sales;
    private String loanAmount;
    private String fundType;
    private String message;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // 기본 생성자
    public ConsultationRequest() {}
    
    // 15개 매개변수 생성자 (consultationProcess.jsp에서 사용)
    public ConsultationRequest(String companyName, String businessNumber, 
                             String contactName, String relationship, String relationshipOther,
                             String phone, String address, String detailAddress, 
                             String ownership, String industry, String sales, 
                             String loanAmount, String fundType, String message, 
                             boolean isActive) {
        this.companyName = companyName;
        this.businessNumber = businessNumber;
        this.contactName = contactName;
        this.relationship = relationship;
        this.relationshipOther = relationshipOther;
        this.phone = phone;
        this.address = address;
        this.detailAddress = detailAddress;
        this.ownership = ownership;
        this.industry = industry;
        this.sales = sales;
        this.loanAmount = loanAmount;
        this.fundType = fundType;
        this.message = message;
        this.status = "대기"; // 기본 상태
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    // 전체 생성자
    public ConsultationRequest(int id, String companyName, String businessNumber, 
                             String contactName, String relationship, String relationshipOther,
                             String phone, String address, String detailAddress, 
                             String ownership, String industry, String sales, 
                             String loanAmount, String fundType, String message, 
                             String status, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.companyName = companyName;
        this.businessNumber = businessNumber;
        this.contactName = contactName;
        this.relationship = relationship;
        this.relationshipOther = relationshipOther;
        this.phone = phone;
        this.address = address;
        this.detailAddress = detailAddress;
        this.ownership = ownership;
        this.industry = industry;
        this.sales = sales;
        this.loanAmount = loanAmount;
        this.fundType = fundType;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getter와 Setter 메서드들
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    
    public String getBusinessNumber() { return businessNumber; }
    public void setBusinessNumber(String businessNumber) { this.businessNumber = businessNumber; }
    
    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }
    
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
    
    public String getLoanAmount() { return loanAmount; }
    public void setLoanAmount(String loanAmount) { this.loanAmount = loanAmount; }
    
    public String getFundType() { return fundType; }
    public void setFundType(String fundType) { this.fundType = fundType; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    @Override
    public String toString() {
        return "ConsultationRequest{" +
                "id=" + id +
                ", companyName='" + companyName + '\'' +
                ", businessNumber='" + businessNumber + '\'' +
                ", contactName='" + contactName + '\'' +
                ", phone='" + phone + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
